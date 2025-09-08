import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_container.dart';
import '../models/trail_model.dart';
import '../core/utils/logger.dart';

class CreateTrailScreen extends StatefulWidget {
  final Function(String, {bool isSubScreen, dynamic data}) onNavigate;

  const CreateTrailScreen({super.key, required this.onNavigate});

  @override
  State<CreateTrailScreen> createState() => _CreateTrailScreenState();
}

class _CreateTrailScreenState extends State<CreateTrailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late PageController _pageController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late ScrollController _scrollController;
  
  int _currentStep = 0;
  String _selectedCategory = 'photography';
  TrailDifficulty _selectedDifficulty = TrailDifficulty.easy;
  bool _isPublic = true;
  bool _allowCollaboration = false;
  String? _selectedCoverImage;
  List<TrailPointData> _trailPoints = [];
  List<String> _selectedTags = [];
  
  final List<String> _categories = [
    'photography',
    'food',
    'nature',
    'urban',
    'art',
    'history',
    'adventure',
    'culture'
  ];
  
  final List<String> _tagOptions = [
    'scenic',
    'family-friendly',
    'instagrammable',
    'hidden-gem',
    'local-favorite',
    'seasonal',
    'indoor',
    'outdoor',
    'walking',
    'cycling',
    'accessible',
    'group-activity'
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pageController = PageController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _scrollController = ScrollController();
    
    _startAnimations();
    Logger.navigation('unknown', 'CreateTrailScreen');
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleCreateTrail() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.hapticFeedback('medium');
    themeProvider.playSound('tap');
    
    Logger.userAction('create_trail', context: {
      'title': _titleController.text,
      'category': _selectedCategory,
      'difficulty': _selectedDifficulty.toString(),
      'points_count': _trailPoints.length,
    });
    
    // Show success animation or processing
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4AA),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4AA).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Trail Created!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your trail has been published successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNavigate('trails');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B1FB3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: themeProvider.colors.background,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(themeProvider),
            body: Column(
              children: [
                // Progress indicator
                _buildProgressIndicator(themeProvider),
                
                // Content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildBasicInfoStep(themeProvider),
                      _buildCategoryStep(themeProvider),
                      _buildPointsStep(themeProvider),
                      _buildSettingsStep(themeProvider),
                    ],
                  ),
                ),
                
                // Navigation buttons
                _buildNavigationButtons(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          themeProvider.hapticFeedback('light');
          widget.onNavigate('trails');
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeProvider.colors.glassBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.colors.glassBorder,
            ),
          ),
          child: const Icon(Icons.close, size: 18),
        ),
      ),
      title: Text(
        'Create Trail',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: themeProvider.colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive 
                    ? themeProvider.colors.accent
                    : themeProvider.colors.glassBg,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _slideController.value)),
            child: Opacity(
              opacity: _slideController.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeProvider.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s start with the basics of your trail',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeProvider.colors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Cover image selector
                  _buildCoverImageSelector(themeProvider),
                  
                  const SizedBox(height: 24),
                  
                  // Title input
                  _buildTextInput(
                    controller: _titleController,
                    label: 'Trail Title',
                    hint: 'Enter a catchy title for your trail',
                    themeProvider: themeProvider,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description input
                  _buildTextInput(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Describe what makes this trail special...',
                    maxLines: 4,
                    themeProvider: themeProvider,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryStep(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category & Difficulty',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help others find your trail by selecting the right category',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Category selection
          Text(
            'Category',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  themeProvider.hapticFeedback('light');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? themeProvider.colors.accent
                        : themeProvider.colors.glassBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                          ? themeProvider.colors.accent
                          : themeProvider.colors.glassBorder,
                    ),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: isSelected 
                          ? Colors.white
                          : themeProvider.colors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Difficulty selection
          Text(
            'Difficulty Level',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: TrailDifficulty.values.map((difficulty) {
              final isSelected = _selectedDifficulty == difficulty;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDifficulty = difficulty;
                  });
                  themeProvider.hapticFeedback('light');
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? themeProvider.colors.accent.withOpacity(0.1)
                        : themeProvider.colors.glassBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                          ? themeProvider.colors.accent
                          : themeProvider.colors.glassBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(difficulty).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getDifficultyIcon(difficulty),
                          color: _getDifficultyColor(difficulty),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              difficulty.name.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: themeProvider.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _getDifficultyDescription(difficulty),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: themeProvider.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: themeProvider.colors.accent,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsStep(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trail Points',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add points of interest along your trail',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Add point button
          GestureDetector(
            onTap: () {
              _showAddPointBottomSheet(themeProvider);
            },
            child: GlassContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: themeProvider.colors.accent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_location,
                      color: themeProvider.colors.accent,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add Trail Point',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: themeProvider.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add locations, viewpoints, or activities',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: themeProvider.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Trail points list
          if (_trailPoints.isNotEmpty) ...[
            Text(
              'Trail Points (${_trailPoints.length})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: themeProvider.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._trailPoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              return _buildTrailPointItem(point, index, themeProvider);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsStep(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trail Settings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure visibility and collaboration settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Visibility settings
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Public Trail',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeProvider.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Anyone can discover and follow this trail',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeProvider.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value;
                        });
                        themeProvider.hapticFeedback('light');
                      },
                      activeColor: themeProvider.colors.accent,
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allow Collaboration',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: themeProvider.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Others can suggest improvements',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: themeProvider.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _allowCollaboration,
                      onChanged: (value) {
                        setState(() {
                          _allowCollaboration = value;
                        });
                        themeProvider.hapticFeedback('light');
                      },
                      activeColor: themeProvider.colors.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tags section
          Text(
            'Tags',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeProvider.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add tags to help others discover your trail',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeProvider.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tagOptions.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                  themeProvider.hapticFeedback('light');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? themeProvider.colors.accent.withOpacity(0.2)
                        : themeProvider.colors.glassBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                          ? themeProvider.colors.accent
                          : themeProvider.colors.glassBorder,
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      color: isSelected 
                          ? themeProvider.colors.accent
                          : themeProvider.colors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: _previousStep,
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(16),
                  child: const Text(
                    'Previous',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: GestureDetector(
              onTap: _currentStep == 3 ? _handleCreateTrail : _nextStep,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B1FB3), Color(0xFF8B4FD9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: themeProvider.colors.shadowPurple,
                ),
                child: Text(
                  _currentStep == 3 ? 'Create Trail' : 'Next',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImageSelector(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Image',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: themeProvider.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            themeProvider.hapticFeedback('light');
            // Handle image selection
          },
          child: GlassContainer(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(20),
            child: _selectedCoverImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      _selectedCoverImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeProvider.colors.accent.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.image,
                          size: 30,
                          color: themeProvider.colors.accent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Add Cover Image',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: themeProvider.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose from gallery or camera',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeProvider.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    required ThemeProvider themeProvider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: themeProvider.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: themeProvider.colors.textTertiary,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: themeProvider.colors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailPointItem(TrailPointData point, int index, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: themeProvider.colors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: themeProvider.colors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeProvider.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (point.description?.isNotEmpty == true)
                    Text(
                      point.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeProvider.colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _trailPoints.removeAt(index);
                });
                themeProvider.hapticFeedback('light');
              },
              icon: Icon(
                Icons.delete_outline,
                color: themeProvider.colors.textTertiary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPointBottomSheet(ThemeProvider themeProvider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GlassContainer(
          margin: const EdgeInsets.all(20),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Trail Point',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: themeProvider.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Point Title',
                  hintText: 'Enter point title',
                  labelStyle: TextStyle(color: themeProvider.colors.textSecondary),
                  hintStyle: TextStyle(color: themeProvider.colors.textTertiary),
                  filled: true,
                  fillColor: themeProvider.colors.glassBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: themeProvider.colors.glassBorder),
                  ),
                ),
                style: TextStyle(color: themeProvider.colors.textPrimary),
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Add details about this point',
                  labelStyle: TextStyle(color: themeProvider.colors.textSecondary),
                  hintStyle: TextStyle(color: themeProvider.colors.textTertiary),
                  filled: true,
                  fillColor: themeProvider.colors.glassBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: themeProvider.colors.glassBorder),
                  ),
                ),
                style: TextStyle(color: themeProvider.colors.textPrimary),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: themeProvider.colors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          setState(() {
                            _trailPoints.add(TrailPointData(
                              title: titleController.text,
                              description: descriptionController.text.isEmpty 
                                  ? null 
                                  : descriptionController.text,
                            ));
                          });
                          Navigator.pop(context);
                          themeProvider.hapticFeedback('medium');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.colors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Point',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(TrailDifficulty difficulty) {
    switch (difficulty) {
      case TrailDifficulty.easy:
        return const Color(0xFF00D4AA);
      case TrailDifficulty.medium:
        return const Color(0xFFFFD700);
      case TrailDifficulty.hard:
        return const Color(0xFFFF6B6B);
    }
  }

  IconData _getDifficultyIcon(TrailDifficulty difficulty) {
    switch (difficulty) {
      case TrailDifficulty.easy:
        return Icons.directions_walk;
      case TrailDifficulty.medium:
        return Icons.directions_bike;
      case TrailDifficulty.hard:
        return Icons.terrain;
    }
  }

  String _getDifficultyDescription(TrailDifficulty difficulty) {
    switch (difficulty) {
      case TrailDifficulty.easy:
        return 'Suitable for everyone, minimal effort required';
      case TrailDifficulty.medium:
        return 'Moderate effort, some planning recommended';
      case TrailDifficulty.hard:
        return 'Challenging, requires good preparation';
    }
  }
}

class TrailPointData {
  final String title;
  final String? description;

  TrailPointData({
    required this.title,
    this.description,
  });
}