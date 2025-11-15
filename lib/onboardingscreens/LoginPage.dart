import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalridr/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digitalridr/core/app_colors.dart';
import 'package:digitalridr/core/app_gradients.dart';
import 'package:digitalridr/onboardingscreens/SignUpPage.dart';
import 'package:digitalridr/screens/Home.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool passwordVisible = true;
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      // 1. Sign In user
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final String uid = _auth.currentUser!.uid;

      // 2. Fetch the user document from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found")),
        );
        return;
      }

      // 3. Extract profile image URL (fallback included)
      String profileImageUrl = userDoc.get('profileImage') ??
          'https://res.cloudinary.com/dzah1rpmd/image/upload/v1699999999/default_avatar.png';

      // 4. Download & Save to app directory
      await CloudinaryService.fetchProfileImage(profileImageUrl, uid);

      // 5. Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );

    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') message = "No user found for that email.";
      if (e.code == 'wrong-password') message = "Wrong password.";

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));
    AppColors.setContext(context);
    AppGradients.setContext(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontScale = screenWidth / 350;

    return Scaffold(
      backgroundColor: AppColors.instance.bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20 * fontScale),
          child: Column(
            children: [
              Text(
                'Login here',
                style: GoogleFonts.poppins(
                    fontSize: 32 * fontScale, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
              SizedBox(height: 15 * fontScale),
              Text(
                "Welcome back you’ve been missed!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: AppColors.instance.textColor),
              ),
              SizedBox(height: 65 * fontScale),
              TextFormField(
                controller: emailController,
                style: GoogleFonts.poppins(
                    fontSize: 18 * fontScale,
                    color: AppColors.instance.textColor
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: const Icon(Icons.email),
                  iconColor: Colors.teal,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16 * fontScale),
              TextFormField(
                controller: passwordController,
                style: GoogleFonts.poppins(
                    fontSize: 18 * fontScale,
                    color: AppColors.instance.textColor
                ),
                decoration: InputDecoration(
                    labelText: 'Password',
                    icon: const Icon(Icons.lock_rounded),
                    iconColor: Colors.teal,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility, size: 24 * fontScale,),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )
                ),
                obscureText: passwordVisible,
              ),
              SizedBox(height: 20 * fontScale),
              isLoading
                  ? const CircularProgressIndicator(color: Colors.teal)
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200 * fontScale, 50 * fontScale),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 20,
                ),
                child: Text(
                  "Sign in",
                  style: GoogleFonts.poppins(
                      fontSize: 18 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20 * fontScale),
                Center(child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
                  },
                  child: Text(
                    "Create New Account",
                    style: GoogleFonts.poppins(fontSize: 16 * fontScale, color: AppColors.instance.textColor),
                  ),
                ),),
              SizedBox(height: 20 * fontScale),
              Center(child: Text("Or continue with", style: GoogleFonts.poppins(fontSize: 16 * fontScale, color: Colors.tealAccent),)),
              SizedBox(height: 12 * fontScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIcon("assets/icons/google_logo.png", fontScale),
                  SizedBox(height: 16 * fontScale),
                  socialIcon("assets/icons/facebook_logo.png", fontScale),
                  SizedBox(height: 16 * fontScale),
                  socialIcon("assets/icons/apple_logo.png", fontScale),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIcon(String assetPath, final double fontScale) {
    return Container(
      padding: EdgeInsets.fromLTRB(18 * fontScale, 12 * fontScale, 18 * fontScale, 12 * fontScale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Image.asset(
        assetPath,
        height: 24 * fontScale,
        width: 24 * fontScale,
        color: Colors.black54,
      ),
    );
  }
}
