import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalridr/custom_icons/digitalridr_app_icons.dart';
import 'package:digitalridr/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalridr/widget/personalised_feed.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:digitalridr/widget/network_aware_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> recommendplaces = [
    'Rock City Gardens',
    'Harpers Ferry',
    'The Butchart Gardens'
  ];
  List<String> recommendcountries = ['Georgia', 'West Virginia', 'Canada'];
  List<String> recommendedimages = [
    'assets/images/rock-city.jpg',
    'assets/images/harpers-ferry.jpg',
    'assets/images/butchart-gardens.webp'
  ];

  int selectedTabIndex = 0;

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final DocumentSnapshot userDoc;
  late final String profileImageUrl;
  late final String profileUserName;
  late final String profileEmail;


  String? _localProfileImagePath;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;


  @override
  void initState()  {
    super.initState();

    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    loadUser();

  }

  Future<void> loadUser() async {

    try {
      final uid = _auth.currentUser!.uid;

      // Fetch Firestore user document
      final userDoc =
      await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        debugPrint("MYAPP : loadUser -> User doc not found");
        return;
      }

      _userData = userDoc.data();

      final profileUrl = _userData!['profileImage'];
      profileUserName = _userData!['username'];


      await Future.delayed(const Duration(seconds: 1));

      // Download & save local copy
      _localProfileImagePath =
      await CloudinaryService.fetchProfileImageFilePath(profileUrl, uid);

    } catch (e) {
      debugPrint("MYAPP : loadUser -> Error loading user: $e");
    }

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Use SafeArea to avoid status bar overlap if you want
      body: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: (165 - MediaQuery.of(context).padding.top)),
                        Expanded(child: NetworkAwareWidget(child: PersonalisedFeed(isLoading: _isLoading))),
                        const SizedBox(height: 40), // bottom padding
                      ],
                    ),
                  ),
                ),
              ),

              //Top Shelf
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.95),
                          Colors.white.withOpacity(0.0),
                        ],
                        //stops: const [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Profile Row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child: _isLoading
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Shimmer(
                                      duration: const Duration(seconds: 10),
                                      interval: const Duration(seconds: 2),
                                      color: Colors.grey.shade100,
                                      colorOpacity: 0.3,
                                      enabled: true,
                                      direction: const ShimmerDirection.fromLTRB(),
                                      child: Container(
                                        padding: const EdgeInsets.all(23),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  )
                                      : CircleAvatar(
                                    radius: 25,
                                    backgroundImage: _localProfileImagePath != null
                                        ? FileImage(File(_localProfileImagePath!))
                                        : const NetworkImage(
                                        "https://res.cloudinary.com/dzah1rpmd/image/upload/v1699999999/default_avatar.png")
                                    as ImageProvider,
                                  ),

                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: _isLoading ?  Shimmer(
                                          duration: const Duration(seconds: 10),
                                          interval: const Duration(seconds: 2),
                                          color: Colors.grey.shade100,
                                          colorOpacity: 0.3,
                                          enabled: true,
                                          direction: const ShimmerDirection.fromLTRB(),
                                          child: Container(
                                            width: 150,
                                            height: 20,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Colors.grey.shade400,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                        ) : Text(
                                          profileUserName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                    ),
                                    _isLoading ? const SizedBox(height: 5) : Container(),
                                    Flexible(
                                      child: _isLoading ?  Shimmer(
                                        duration: const Duration(seconds: 10),
                                        interval: const Duration(seconds: 2),
                                        color: Colors.grey.shade100,
                                        colorOpacity: 0.3,
                                        enabled: true,
                                        direction: const ShimmerDirection.fromLTRB(),
                                        child: Container(
                                          width: 100,
                                          height: 20,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                      ) : const Text(
                                        "4 New Notifications",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Notification Icon
                            _isLoading ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Shimmer(
                                duration: const Duration(seconds: 10),
                                interval: const Duration(seconds: 2),
                                color: Colors.grey.shade100,
                                colorOpacity: 0.3,
                                enabled: true,
                                direction: const ShimmerDirection.fromLTRB(),
                                child: Container(
                                  padding: const EdgeInsets.all(23),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(DigitalridrAppIcons.notifications, color: Colors.black87),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15.0),

                      // Search Bar (use SizedBox rather than Expanded)
                      _isLoading ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Shimmer(
                          duration: const Duration(seconds: 10),
                          interval: const Duration(seconds: 2),
                          color: Colors.grey.shade100,
                          colorOpacity: 0.3,
                          enabled: true,
                          direction: const ShimmerDirection.fromLTRB(),
                          child: Container(
                            padding: const EdgeInsets.all(23),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      )
                          : Container(
                        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 3),
                              ),]
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Stack(
                                    children: [
                                      Positioned.fill(child: Icon(Icons.location_searching, color: Colors.grey, size: 25,)),
                                      Positioned(top: 3, bottom: 3, left: 3, right: 3, child: Icon(Icons.location_on, color: Colors.grey, size: 13,))
                                    ]
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Lagos",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15,),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
