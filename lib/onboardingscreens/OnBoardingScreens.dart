import 'package:digitalridr/core/app_colors.dart';
import 'package:digitalridr/core/app_gradients.dart';
import 'package:digitalridr/onboardingscreens/WelcomePage.dart';
import 'package:digitalridr/tools/hexToColor.dart';
import 'package:flutter/material.dart';
import 'package:digitalridr/models/onboarding_model.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: "Best In The Biz",
      description: "At DigitalRidr, we turn data into decisions delivering premium services and unbeatable deals made just for you.",
      skipText: "Skip",
      lottiePath: 'assets/lottie/data_analyst.json',
    ),
    OnboardingItem(
      title: "Find Your Place",
      description: "Discover apartments that truly match your vibe stylish, comfy, and perfectly priced.",
      skipText: "Skip",
      lottiePath: 'assets/lottie/locationonmap.json',
    ),
    OnboardingItem(
      title: "Find Your Happy Place",
      description: "From city views to cozy corners explore apartments that make every stay feel like a getaway.",
      lottiePath: 'assets/lottie/cartravellingcity.json',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: _isDarkMode ? Brightness.dark : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: _isDarkMode ? Brightness.dark : Brightness.light,

    ));

    AppGradients.setContext(context);
    AppColors.setContext(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontScale = screenWidth / 350;


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.loginSignupGradient,
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingItems.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return _buildPage(_onboardingItems[index], screenWidth, screenHeight, fontScale);
              },
            ),
            Positioned(
              top: 50,
              right: 20,
              child: _currentPage != _onboardingItems.length - 1
                  ? TextButton(
                onPressed: () => _navigateToLastPage(),
                child: Text(
                  _onboardingItems[_currentPage].skipText ?? "Skip",
                  style: GoogleFonts.poppins(
                    fontSize: 16 * fontScale,
                    //fontSize: screenWidth < 600 ? (screenWidth < 320 ? 14 : 16) : 20,
                    color: AppColors.instance.textColor, // Match your splash screen style
                  ),
                ),
              )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomNavigation(screenHeight,screenWidth,fontScale),
    );
  }

  Widget _buildPage(OnboardingItem item, double screenWidth, double screenHeight, double fontScale) {
    String imageUrl = item.lottiePath;
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Align(
        alignment: AlignmentGeometry.bottomCenter,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Replace with your actual image widget
              Center(
                child: Lottie.asset(
                  imageUrl,
                  height: screenWidth - 65,
                  //height: screenWidth < 600 ? (screenWidth < 320 ? (screenWidth < 250 ? 185 : 220) : 285) : 350,
                  fit: BoxFit.cover,
                  repeat: false,
                  animate: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                child: Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 24 * fontScale,
                    //fontSize: screenWidth < 600 ? (screenWidth < 320 ? 18 : 24) : 30 ,
                    color: AppColors.instance.textColor,
                    fontWeight: FontWeight.bold,
                    // Match your splash screen typography
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                child: Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    fontSize: 16 * fontScale,
                    //fontSize: screenWidth < 600 ? (screenWidth < 320 ? 14 : 16) : 20,
                    color: AppColors.instance.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 170,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(double screenHeight, double screenWidth, double fontScale) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.instance.bgColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(28.0),topRight: Radius.circular(28.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page indicators
          Row(
            children: List.generate(
              _onboardingItems.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? hexToColor('#FF7F50') // Active color
                      : Colors.grey[300], // Inactive color
                ),
              ),
            ),
          ),
          // Next/Get Started button
          ElevatedButton(
            onPressed: () async {
              if (_currentPage == _onboardingItems.length - 1) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
                await saveDecidingFile();
                // Navigate to home screen
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: hexToColor('#40E0D0'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              // Match your splash screen button style
            ),
            child: Text(
              _currentPage == _onboardingItems.length - 1
                  ? "Dive In"
                  : "Next",
              style: GoogleFonts.poppins(
                color: AppColors.instance.textColor,
                fontSize: 16 * fontScale,
                //fontSize: screenWidth < 600 ? (screenWidth < 320 ? 14 : 16) : 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveDecidingFile() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    await prefs.setBool('hasSeenOnboarding', true);
  }

  void _navigateToLastPage() {
    _pageController.animateToPage(
      _onboardingItems.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}