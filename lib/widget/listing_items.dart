import 'dart:math';

import 'package:digitalridr/custom_icons/digitalridr_app_icons.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:digitalridr/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../tools/formatNumToMoney.dart';

Widget listingItem(BuildContext context, Apartment apartment, int i, bool isLoading){
  final screenWidth = MediaQuery.of(context).size.width;

  // Dynamic sizing
  final double cardWidth = screenWidth * 0.42; // adaptive width
  final double cardHeight = cardWidth * 0.85;
  final double fontScale = screenWidth / 350; // text scaling factor

  return GestureDetector(
    onTap: () => travelPage(context,i,apartment),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Apartment image with shadow
        isLoading ? Shimmer(
          duration: const Duration(seconds: 10),
          interval: const Duration(seconds: 2),
          color: Colors.grey.shade100,
          colorOpacity: 0.3,
          enabled: true,
          direction: const ShimmerDirection.fromLTRB(),
          child: Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20)
            ),
          ),
        ) :
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10), // bottom shadow
              ),
            ],
          ),
          height: cardHeight,
          width: cardWidth,
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  apartment.images[0],
                  width: cardWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),

              // Dim overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),

              // Rating tag
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        apartment.rating.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13 * fontScale,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.star_rounded, color: Colors.amber, size: 16 * fontScale),
                    ],
                  ),
                ),
              ),

              // Bookmark icon
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      DigitalridrAppIcons.bookmark_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Apartment info
        SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (space type + city)
                isLoading ? Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: Shimmer(
                    duration: const Duration(seconds: 10),
                    interval: const Duration(seconds: 2),
                    color: Colors.grey.shade100,
                    colorOpacity: 0.3,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ) :
                Text(
                  '${getSpaceType(apartment.guestSpace)} in ${apartment.city}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                const SizedBox(height: 1),

                // Price & details
                isLoading ? Shimmer(
                  duration: const Duration(seconds: 10),
                  interval: const Duration(seconds: 2),
                  color: Colors.grey.shade300,
                  colorOpacity: 0.3,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: 65,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ) :
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '₦',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w600,
                          fontSize: 12 * fontScale,
                        ),
                      ),
                      TextSpan(
                        text: formatNumToMoney(apartment.price),
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w600,
                          fontSize: 12 * fontScale,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: ' for ${apartment.listingDuration} • ${apartment.amountOfBeds} beds',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11 * fontScale,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget listingItemShimerring(BuildContext context,bool isLoading){
  final screenWidth = MediaQuery.of(context).size.width;

  // Dynamic sizing
  final double cardWidth = screenWidth * 0.42; // adaptive width
  final double cardHeight = cardWidth * 0.85;
  final double fontScale = screenWidth / 350; // text scaling factor

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Apartment image with shadow
      Shimmer(
        duration: const Duration(seconds: 10),
        interval: const Duration(seconds: 2),
        color: Colors.grey.shade100,
        colorOpacity: 0.3,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20)
          ),
        ),
      ),
      const SizedBox(height: 4),

      // Apartment info
      SizedBox(
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (space type + city)
              Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Shimmer(
                  duration: const Duration(seconds: 10),
                  interval: const Duration(seconds: 2),
                  color: Colors.grey.shade100,
                  colorOpacity: 0.3,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 1),

              // Price & details
              Shimmer(
                duration: const Duration(seconds: 10),
                interval: const Duration(seconds: 2),
                color: Colors.grey.shade300,
                colorOpacity: 0.3,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  width: 65,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.shade300,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}


Widget listingItem4(BuildContext context, Apartment apartment, int i, bool isLoading, List<Apartment> apartments) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height * 0.75;
  final double cardWidth = screenWidth * 0.42; // adaptive width
  final double cardHeight = cardWidth * 0.85;
  final double fontScale = screenWidth / 350;

  return Container(
    margin: const EdgeInsets.only(bottom: 2),
    height: cardHeight + 100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.04),
          child: isLoading ? Container(
            margin: const EdgeInsets.only(bottom: 4 , left: 5),
            child: Shimmer(
              duration: const Duration(seconds: 10),
              interval: const Duration(seconds: 2),
              color: Colors.grey.shade300,
              colorOpacity: 0.3,
              enabled: true,
              direction: const ShimmerDirection.fromLTRB(),
              child: Container(
                padding: const EdgeInsets.all(4),
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ) : TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {
              // Navigate or show more
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    "Places Near ${apartment.city}",
                    style: TextStyle(
                      fontSize: 18 * fontScale.clamp(0.85, 1.2),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 2),

        // Horizontal list of apartments
        SizedBox(
          height: cardHeight + 50, // responsive height (good for small & large screens)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: apartments.length,
            padding: EdgeInsets.only(left: screenWidth * 0.05),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: listingItem(context, apartments[index], index, isLoading),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget listingItem4Shimmering(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height * 0.75;
  final double cardWidth = screenWidth * 0.42; // adaptive width
  final double cardHeight = cardWidth * 0.85;
  final double fontScale = screenWidth / 350;
  bool isLoading = true;

  return Container(
    margin: const EdgeInsets.only(bottom: 2),
    height: cardHeight + 100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.04),
          child: Shimmer(
            duration: const Duration(seconds: 10),
            interval: const Duration(seconds: 2),
            color: Colors.grey.shade300,
            colorOpacity: 0.3,
            enabled: true,
            direction: const ShimmerDirection.fromLTRB(),
            child: Container(
              padding: const EdgeInsets.all(4),
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),

        const SizedBox(height: 2),

        // Horizontal list of apartments
        SizedBox(
          height: cardHeight + 50, // responsive height (good for small & large screens)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            padding: EdgeInsets.only(left: screenWidth * 0.05),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: listingItemShimerring(context, true),
              );
            },
          ),
        ),
      ],
    ),
  );
}

int? _lastChoice; // store the last random choice globally or in a class


String getSpaceType(GuestSpace g){
  String space;

  switch(g.name){
    case "entireApartment" :
      space = "Flat";
      break;
    case "room" :
      space = "A Room";
      break;
    case "sharedHostel" :
      space = "Hostel";
      break;
    default :
      space = "Flat";

  }

  return space;
}
