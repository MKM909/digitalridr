import 'package:digitalridr/core/theme_manager.dart';
import 'package:digitalridr/firebase_options.dart';
import 'package:digitalridr/onboardingscreens/OnBoardingScreens.dart';
import 'package:digitalridr/onboardingscreens/WelcomePage.dart';
import 'package:digitalridr/screens/Home.dart';
import 'package:digitalridr/onboardingscreens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeManager = ThemeManager();
  await themeManager.initialize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));

  // Lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider.value(
      value: themeManager,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? startScreen;

  @override
  void initState() {
    super.initState();
    _checkStartScreen();
  }

  Future<void> _checkStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    final user = FirebaseAuth.instance.currentUser;

    // 👇 Determine which screen to show
    if(hasSeenOnboarding){
      startScreen = user != null ? const Home() : const WelcomeScreen();
    } else {
      startScreen = const OnboardingScreen();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode,
          debugShowCheckedModeBanner: false,
          home: startScreen ??
              const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
        );
      },
    );
  }
}
