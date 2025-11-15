import 'package:digitalridr/core/app_colors.dart';
import 'package:digitalridr/core/app_gradients.dart';
import 'package:digitalridr/onboardingscreens/LoginPage.dart';
import 'package:digitalridr/onboardingscreens/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../tools/hexToColor.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));
    AppGradients.setContext(context);
    AppColors.setContext(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontScale = screenWidth / 350;


    return Scaffold(
      backgroundColor: AppColors.instance.bgColor,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Align(
          alignment: AlignmentGeometry.center,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/lottie/eco_friendly_city.json',
                        width: screenWidth - 65,
                        repeat: false,
                        animate: true,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'Live Where You Love',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 28 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.instance.textColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'From modern city apartments to peaceful retreats — your ideal space awaits.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 13 * fontScale,
                              color: AppColors.instance.textColor),
                        ),
                        const SizedBox(height: 60,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 50),
                                shape:  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                backgroundColor: hexToColor('#40E0D0'),
                                shadowColor: hexToColor('#000000'),
                                elevation: 20
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                    fontSize: 16 * fontScale,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.instance.textColor),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16 * fontScale,
                                            color: AppColors.instance.textColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}