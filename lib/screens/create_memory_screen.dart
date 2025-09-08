import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../core/utils/logger.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class CreateMemoryScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const CreateMemoryScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<CreateMemoryScreen> createState() => _CreateMemoryScreenState();
}

class _CreateMemoryScreenState extends State<CreateMemoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  // Form state
  String _selectedCategory = '';
  String _selectedVisibility = 'public';
  bool _isSubmitting = false;
  List<String> _selectedImages = [];
  String _currentLocation = 'Current Location';

  final List<MemoryCategory> _categories = [
    MemoryCategory(
      id: 'food',
      name: 'Food & Drinks',
      icon: Icons.restaurant_rounded,
      color: Colors.orange,
    ),
    MemoryCategory(
      id: 'art',
      name: 'Art & Culture',
      icon: Icons.palette_rounded,
      color: Colors.purple,
    ),
    MemoryCategory(
      id: 'nature',
      name: 'Nature',
      icon: Icons.nature_rounded,
      color: Colors.green,
    ),
    MemoryCategory(
      id: 'wellness',
      name: 'Wellness',
      icon: Icons.spa_rounded,
      color: Colors.blue,
    ),
    MemoryCategory(
      id: 'events',
      name: 'Events',
      icon: Icons.event_rounded,
      color: Colors.red,
    ),
    MemoryCategory(
      id: 'photography',
      name: 'Photography',
      icon: Icons.camera_alt_rounded,
      color: Colors.indigo,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Logger.info('Create memory screen initialized');
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    _updateProgress();
  }

  void _updateProgress() {
    _progressController.animateTo((_currentStep + 1) / _totalSteps);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    Logger.info('Create memory screen disposed');
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: AppAnimations.medium,
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: AppAnimations.medium,
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _submitMemory() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('success');
    themeProvider.playSound('success');

    setState(() => _isSubmitting = true);

    // Simulate submission delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);
    
    // Navigate back to home
    widget.onNavigate('home');
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedImages.isNotEmpty;
      case 1:
        return _titleController.text.isNotEmpty && _selectedCategory.isNotEmpty;
      case 2:
        return _descriptionController.text.isNotEmpty;
      case 3:
        return true; // Review step
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.colors;
        final mediaQuery = MediaQuery.of(context);
        final screenWidth = mediaQuery.size.width;
        final isSmallScreen = screenWidth < 380;
        final isMediumScreen = screenWidth >= 380 && screenWidth < 414;
        
        return Container(
          decoration: BoxDecoration(gradient: colors.background),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: AnimatedBuilder(
                animation: Listenable.merge([_slideController, _fadeController]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Column(
                        children: [
                          _buildHeader(colors, themeProvider, isSmallScreen, isMediumScreen),
                          _buildProgressBar(colors, isSmallScreen, isMediumScreen),
                          Expanded(
                            child: _buildSteps(colors, themeProvider, isSmallScreen, isMediumScreen),
                          ),
                          _buildBottomActions(colors, themeProvider, isSmallScreen, isMediumScreen),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final titleFontSize = isSmallScreen ? 18.0 : isMediumScreen ? 20.0 : 22.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : isMediumScreen ? 13.0 : 14.0;
    
    final stepTitles = [
      'Choose Photos',
      'Add Details',
      'Write Story',
      'Review & Share',
    ];
    
    return Container(
      padding: EdgeInsets.all(horizontalPadding),
      child: Row(
        children: [
          // Close button
          GlassContainer(
            onTap: () {
              themeProvider.hapticFeedback('light');
              widget.onNavigate('home');
            },
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 10.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Icon(
              Icons.close_rounded,
              color: colors.textPrimary,
              size: isSmallScreen ? 20.0 : 22.0,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title and step
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Memory',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: titleFontSize,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step ${_currentStep + 1}: ${stepTitles[_currentStep]}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AppColors colors, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      child: Column(
        children: [
          // Progress indicators
          Row(
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: AppAnimations.medium,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: isCompleted || isCurrent 
                              ? colors.gradientPrimary 
                              : null,
                          color: isCompleted || isCurrent 
                              ? null 
                              : colors.glassBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < _totalSteps - 1) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Progress percentage
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Text(
                '${(_progressAnimation.value * 100).round()}% Complete',
                style: TextStyle(
                  fontSize: isSmallScreen ? 11.0 : 12.0,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildPhotoStep(colors, themeProvider, isSmallScreen, isMediumScreen),
        _buildDetailsStep(colors, themeProvider, isSmallScreen, isMediumScreen),
        _buildStoryStep(colors, themeProvider, isSmallScreen, isMediumScreen),
        _buildReviewStep(colors, themeProvider, isSmallScreen, isMediumScreen),
      ],
    );
  }

  Widget _buildPhotoStep(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your photos',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Select up to 5 photos to tell your story',
            style: TextStyle(
              fontSize: isSmallScreen ? 13.0 : 14.0,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Photo grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 2 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: 6, // 5 for photos + 1 for add button
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddPhotoButton(colors, themeProvider, isSmallScreen);
              }
              
              if (index <= _selectedImages.length) {
                return _buildSelectedPhoto(index - 1, colors, themeProvider);
              }
              
              return _buildEmptyPhotoSlot(colors);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    return GlassContainer(
      onTap: () {
        themeProvider.hapticFeedback('light');
        // Add demo image
        setState(() {
          if (_selectedImages.length < 5) {
            _selectedImages.add('https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400');
          }
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
                  decoration: BoxDecoration(
                    gradient: colors.gradientPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: isSmallScreen ? 24.0 : 28.0,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Add Photo',
            style: TextStyle(
              fontSize: isSmallScreen ? 12.0 : 14.0,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPhoto(int index, AppColors colors, ThemeProvider themeProvider) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Image.network(
            _selectedImages[index],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              themeProvider.hapticFeedback('light');
              setState(() => _selectedImages.removeAt(index));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPhotoSlot(AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.glassBg,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: colors.glassBorder,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.photo_rounded,
        color: colors.textSecondary.withOpacity(0.3),
        size: 32,
      ),
    );
  }

  Widget _buildDetailsStep(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add details',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title input
          _buildInputField(
            'Memory Title',
            'Give your memory a catchy title',
            _titleController,
            colors,
            isSmallScreen,
          ),
          
          const SizedBox(height: 20),
          
          // Category selection
          Text(
            'Category',
            style: TextStyle(
              fontSize: isSmallScreen ? 14.0 : 16.0,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category.id;
              return GestureDetector(
                onTap: () {
                  themeProvider.hapticFeedback('light');
                  setState(() => _selectedCategory = category.id);
                },
                child: AnimatedContainer(
                  duration: AppAnimations.medium,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12.0 : 16.0,
                    vertical: isSmallScreen ? 8.0 : 10.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? colors.gradientPrimary : null,
                    color: isSelected ? null : colors.glassBg,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : colors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        size: isSmallScreen ? 16.0 : 18.0,
                        color: isSelected ? Colors.white : category.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12.0 : 14.0,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Location
          _buildLocationField(colors, themeProvider, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildStoryStep(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell your story',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Description input
          GlassContainer(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: TextField(
              controller: _descriptionController,
              maxLines: 8,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: isSmallScreen ? 14.0 : 16.0,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Share what made this moment special...',
                hintStyle: TextStyle(
                  color: colors.textSecondary,
                  fontSize: isSmallScreen ? 14.0 : 16.0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tags input
          _buildInputField(
            'Tags (Optional)',
            '#coffee #morning #peaceful',
            _tagsController,
            colors,
            isSmallScreen,
          ),
          
          const SizedBox(height: 20),
          
          // Privacy settings
          _buildPrivacySettings(colors, themeProvider, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildReviewStep(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review your memory',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Preview card
          GlassContainer(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
            borderRadius: BorderRadius.circular(AppRadius.premium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photos preview
                if (_selectedImages.isNotEmpty)
                  Container(
                    height: isSmallScreen ? 200.0 : 240.0,
                    child: PageView.builder(
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: Image.network(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Title
                if (_titleController.text.isNotEmpty)
                  Text(
                    _titleController.text,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16.0 : 18.0,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                // Description
                if (_descriptionController.text.isNotEmpty)
                  Text(
                    _descriptionController.text,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13.0 : 14.0,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Meta info
                Row(
                  children: [
                    if (_selectedCategory.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _categories.firstWhere((c) => c.id == _selectedCategory).name,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10.0 : 12.0,
                            fontWeight: FontWeight.w600,
                            color: colors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      Icons.location_on_rounded,
                      size: isSmallScreen ? 12.0 : 14.0,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentLocation,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11.0 : 12.0,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _selectedVisibility == 'public' 
                          ? Icons.public_rounded 
                          : Icons.lock_rounded,
                      size: isSmallScreen ? 12.0 : 14.0,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, AppColors colors, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14.0 : 16.0,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        GlassContainer(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: isSmallScreen ? 14.0 : 16.0,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: colors.textSecondary,
                fontSize: isSmallScreen ? 14.0 : 16.0,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: isSmallScreen ? 14.0 : 16.0,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        GlassContainer(
          onTap: () {
            themeProvider.hapticFeedback('light');
            // TODO: Open location picker
          },
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: colors.accent,
                size: isSmallScreen ? 20.0 : 22.0,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _currentLocation,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: isSmallScreen ? 14.0 : 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: isSmallScreen ? 20.0 : 22.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy',
          style: TextStyle(
            fontSize: isSmallScreen ? 14.0 : 16.0,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: _buildPrivacyOption(
                'public',
                'Public',
                Icons.public_rounded,
                'Everyone can see',
                colors,
                themeProvider,
                isSmallScreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPrivacyOption(
                'private',
                'Private',
                Icons.lock_rounded,
                'Only you',
                colors,
                themeProvider,
                isSmallScreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacyOption(String value, String title, IconData icon, String subtitle, AppColors colors, ThemeProvider themeProvider, bool isSmallScreen) {
    final isSelected = _selectedVisibility == value;
    
    return GestureDetector(
      onTap: () {
        themeProvider.hapticFeedback('light');
        setState(() => _selectedVisibility = value);
      },
      child: AnimatedContainer(
        duration: AppAnimations.medium,
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        decoration: BoxDecoration(
          gradient: isSelected ? colors.gradientPrimary : null,
          color: isSelected ? null : colors.glassBg,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: isSelected ? Colors.transparent : colors.glassBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : colors.accent,
              size: isSmallScreen ? 24.0 : 28.0,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 12.0 : 14.0,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isSmallScreen ? 10.0 : 11.0,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.white70 : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(AppColors colors, ThemeProvider themeProvider, bool isSmallScreen, bool isMediumScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : isMediumScreen ? 20.0 : 24.0;
    final buttonHeight = isSmallScreen ? 48.0 : isMediumScreen ? 52.0 : 56.0;
    final fontSize = isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.all(horizontalPadding),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            Expanded(
              child: GlassContainer(
                onTap: _previousStep,
                height: buttonHeight,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: Center(
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          // Next/Submit button
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: AnimatedContainer(
              duration: AppAnimations.medium,
              height: buttonHeight,
              decoration: BoxDecoration(
                gradient: _canProceed() ? colors.gradientPrimary : null,
                color: _canProceed() ? null : colors.glassBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                boxShadow: _canProceed() ? colors.shadowPurple : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _canProceed() ? (_currentStep == _totalSteps - 1 ? _submitMemory : _nextStep) : null,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Center(
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == _totalSteps - 1 ? 'Share Memory' : 'Next',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: _canProceed() ? Colors.white : colors.textSecondary,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  MemoryCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}