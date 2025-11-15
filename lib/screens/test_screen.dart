
import 'package:digitalridr/customui/animated_nav_bar.dart';
import 'package:flutter/material.dart';
import '../customui/frosted_bottom_nav.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.domain_rounded,
    Icons.bookmark_rounded,
    Icons.chat_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Text(
          "Tab $_selectedIndex",
          style: const TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
      bottomNavigationBar: AnimatedNavBar(
          currentIndex: _selectedIndex,
          onItemSelected: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
          icons: _icons),
    );
  }
}