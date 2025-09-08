import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../core/constants/app_constants.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isScanning = false;
  int _memoriesFound = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _toggleScanning() async {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.hapticFeedback(HapticFeedbackType.medium);
    
    setState(() {
      _isScanning = !_isScanning;
    });
    
    if (_isScanning) {
      _scanController.repeat();
      // Simulate finding memories
      for (int i = 0; i < 5; i++) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted && _isScanning) {
          setState(() {
            _memoriesFound++;
          });
          themeProvider.hapticFeedback(HapticFeedbackType.light);
        }
      }
    } else {
      _scanController.stop();
      setState(() {
        _memoriesFound = 0;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF000000),
                    const Color(0xFF1A0A2E),
                  ]
                : [
                    const Color(0xFFF8F7FF),
                    const Color(0xFFE8E5FF),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // AR Camera View Simulation
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? Colors.black : Colors.white).withOpacity(0.3),
                  ],
                ),
              ),
            ),
            
            // AR Scanning Overlay
            if (_isScanning) _buildScanningOverlay(size, isDark),
            
            // Memory Indicators
            ..._buildMemoryIndicators(size, isDark),
            
            // Top Status Bar
            _buildTopStatusBar(isDark),
            
            // Bottom Controls
            _buildBottomControls(size, isDark, themeProvider),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScanningOverlay(Size size, bool isDark) {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: ScanlinePainter(
            progress: _scanAnimation.value,
            color: AppConstants.royalPurple,
            isDark: isDark,
          ),
        );
      },
    );
  }
  
  List<Widget> _buildMemoryIndicators(Size size, bool isDark) {
    if (!_isScanning) return [];
    
    return List.generate(_memoriesFound, (index) {
      final left = (index * 80.0 + 50) % (size.width - 100);
      final top = (index * 120.0 + 200) % (size.height - 400);
      
      return Positioned(
        left: left,
        top: top,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GlassContainer(
                padding: const EdgeInsets.all(AppConstants.spacingS),
                borderRadius: AppConstants.radiusS,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppConstants.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingXS),
                    Text(
                      'Memory ${index + 1}',
                      style: AppConstants.bodySmall.copyWith(
                        color: isDark
                            ? AppConstants.darkTextPrimary
                            : AppConstants.lightTextPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
  
  Widget _buildTopStatusBar(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingS,
              ),
              borderRadius: AppConstants.radiusL,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppConstants.royalPurple,
                  ),
                  const SizedBox(width: AppConstants.spacingXS),
                  Text(
                    'San Francisco',
                    style: AppConstants.bodySmall.copyWith(
                      color: isDark
                          ? AppConstants.darkTextPrimary
                          : AppConstants.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingS,
              ),
              borderRadius: AppConstants.radiusL,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Scanned: ',
                    style: AppConstants.bodySmall.copyWith(
                      color: isDark
                          ? AppConstants.darkTextSecondary
                          : AppConstants.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '$_memoriesFound',
                    style: AppConstants.bodySmall.copyWith(
                      color: AppConstants.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomControls(Size size, bool isDark, ThemeProvider themeProvider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AR Crosshair
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.royalPurple.withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppConstants.royalPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Corner indicators
                    ..._buildCornerIndicators(),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Scan Button
              GestureDetector(
                onTap: _toggleScanning,
                child: AnimatedContainer(
                  duration: AppConstants.animationMedium,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isScanning
                          ? [AppConstants.gold, AppConstants.gold.withOpacity(0.8)]
                          : [AppConstants.royalPurple, AppConstants.lavender],
                    ),
                    boxShadow: _isScanning
                        ? AppConstants.shadowGold
                        : AppConstants.shadowPurple,
                  ),
                  child: Icon(
                    _isScanning ? Icons.stop : Icons.center_focus_strong,
                    color: AppConstants.pureWhite,
                    size: 32,
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingM),
              
              // Instructions
              Text(
                _isScanning 
                    ? 'Scanning for memories...' 
                    : 'Tap to scan for AR memories',
                style: AppConstants.bodyMedium.copyWith(
                  color: isDark
                      ? AppConstants.darkTextSecondary
                      : AppConstants.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildCornerIndicators() {
    const positions = [
      {'top': 8.0, 'left': 8.0},
      {'top': 8.0, 'right': 8.0},
      {'bottom': 8.0, 'left': 8.0},
      {'bottom': 8.0, 'right': 8.0},
    ];
    
    return positions.map((pos) {
      return Positioned(
        top: pos['top'] as double?,
        left: pos['left'] as double?,
        right: pos['right'] as double?,
        bottom: pos['bottom'] as double?,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppConstants.gold,
              width: 2,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppConstants.gold.withOpacity(0.3),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class ScanlinePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;
  
  ScanlinePainter({
    required this.progress,
    required this.color,
    required this.isDark,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Horizontal scanline
    final y = size.height * progress;
    
    // Draw shadow line
    canvas.drawLine(
      Offset(0, y + 1),
      Offset(size.width, y + 1),
      shadowPaint,
    );
    
    // Draw main line
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
    
    // Draw scan effects
    final effectPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withOpacity(0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));
    
    canvas.drawRect(
      Rect.fromLTWH(0, y - 20, size.width, 40),
      effectPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ScanlinePainter && oldDelegate.progress != progress;
  }
}