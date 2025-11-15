import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ApartmentPage extends StatefulWidget {
  const ApartmentPage({super.key});

  @override
  State<ApartmentPage> createState() => _ApartmentPageState();
}

class _ApartmentPageState extends State<ApartmentPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Container(
            color: Colors.white,
            child:  Center(
                child: Lottie.asset(
                  'assets/lottie/empty_ghost.json',
                  width: screenWidth - 65,
                  repeat: false,
                  animate: true,
                ),
          ),
        ),
      ),
      )
    );
  }
}
