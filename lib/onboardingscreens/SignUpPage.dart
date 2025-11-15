import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalridr/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import '../core/app_gradients.dart';
import '../screens/Home.dart';
import 'LoginPage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool passwordVisible = true;
  bool passwordVisible2 = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _profileImage;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _signUp() async {
    if (passwordController.text.trim() != confirmController.text.trim()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Username is required")));
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String? imageUrl;
      if (_profileImage != null) {
        imageUrl = await CloudinaryService.uploadAndSaveLocally(
            _profileImage!, '${userCredential.user!.uid}.jpg');
      }

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'profileImage': imageUrl ??
            'https://res.cloudinary.com/dzah1rpmd/image/upload/v1699999999/default_avatar.png',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == 'email-already-in-use') message = "Email already in use.";
      if (e.code == 'weak-password') message = "Password too weak.";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppColors.setContext(context);
    AppGradients.setContext(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fontScale = screenWidth / 350;


    return Scaffold(
      backgroundColor: AppColors.instance.bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25 * fontScale),
          child: Column(
            children: [
              SizedBox(height: 20 * fontScale),
              Text('Create Account',
                  style: GoogleFonts.poppins(
                      fontSize: 32 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent)),
              SizedBox(height: 20 * fontScale),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45 * fontScale,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.add_a_photo, color: Colors.teal, size: 24 * fontScale)
                      : null,
                ),
              ),
              SizedBox(height: 20 * fontScale),
              TextFormField(
                controller: usernameController,
                style: GoogleFonts.poppins(
                  fontSize: 18 * fontScale,
                  color: AppColors.instance.textColor
                ),
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: const Icon(Icons.person),
                  iconColor: Colors.teal,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16 * fontScale),
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
              SizedBox(height: 16 * fontScale),
              TextFormField(
                controller: confirmController,
                style: GoogleFonts.poppins(
                    fontSize: 18 * fontScale,
                    color: AppColors.instance.textColor
                ),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  icon: const Icon(Icons.lock_outline_rounded),
                  iconColor: Colors.teal,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible2 ? Icons.visibility_off : Icons.visibility, size: 24 * fontScale,),
                      onPressed: () {
                        setState(() {
                          passwordVisible2 = !passwordVisible2;
                        });
                      },
                    )
                ),
                obscureText: passwordVisible2,
              ),
              SizedBox(height: 30 * fontScale),
              isLoading
                  ? const CircularProgressIndicator(color: Colors.teal)
                  : ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(200 * fontScale, 50 * fontScale),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(
                  "Sign up",
                  style: GoogleFonts.poppins(
                      fontSize: 18 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20 * fontScale),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    "Already Have An Account? Sign In",
                    style: GoogleFonts.poppins(
                        fontSize: 16 * fontScale, color: AppColors.instance.textColor),
                  ),
                ),
              ),
              SizedBox(height: 20 * fontScale),
              Center(child: Text("Or continue with", style: GoogleFonts.poppins(fontSize: 16 * fontScale, color: Colors.tealAccent),)),
              SizedBox(height: 12 * fontScale),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIcon("assets/icons/google_logo.png", fontScale),
                  SizedBox(width: 16 * fontScale),
                  socialIcon("assets/icons/facebook_logo.png", fontScale),
                  SizedBox(width: 16 * fontScale),
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
