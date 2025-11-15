import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
