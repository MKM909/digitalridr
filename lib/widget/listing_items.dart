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
                child: Image.asset(
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

Widget unboundedListingItem(BuildContext context, Apartment apartment, int i){
  return GestureDetector(
    onTap: () => travelPage(context,i,apartment),
    child: SizedBox(
      width: 155,
      height: 300,
      child: Stack(
          children: [
            Hero(
              tag: 'travel-description-image$i',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  apartment.images[0],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),

            // Rating
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          apartment.rating.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          )
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  DigitalridrAppIcons.location,
                                  color: Colors.black,
                                  size: 13,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  apartment.city,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₦',
                                      style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 1,
                                    ),
                                    Text(
                                        formatNumToMoney(apartment.price),
                                        style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 1
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  ' ${apartment.listingDuration}',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ),

            //Bookmark icon
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: (){},
                      focusColor: Colors.grey.shade300,
                      child: const Icon(
                        DigitalridrAppIcons.bookmark_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                )
            ),

          ]
      ),
    ),
  );
}

Widget listingItem2(BuildContext context, Apartment apartment, int i){

  return GestureDetector(
    onTap: () => travelPage(context,i,apartment),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                //Profile Row
                Row(
                  children: [
                    //Profile Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const AssetImage('assets/images/zenitsu.jpg'),
                    ),
                    const SizedBox(width: 10),
                    //Profile Info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apartment.publishedBy,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          apartment.contact,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.grey.shade500,
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10,),

                SizedBox(
                  height: 300,
                  child: Stack(
                      children: [
                        Hero(
                          tag: 'travel-description-image$i',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              apartment.images[0],
                              fit: BoxFit.cover,
                              height: 300,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),

                        // Rating
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      apartment.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      )
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100.withValues(alpha: 0.9),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        apartment.city,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w300
                                        ),
                                      ),
                                    ),
                                    //Description
                                    Flexible(
                                      child: Text(
                                        apartment.description,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '₦',
                                                style: TextStyle(
                                                    color: Colors.grey.shade900,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                maxLines: 1,
                                              ),
                                              Text(
                                                  formatNumToMoney(apartment.price),
                                                  style: TextStyle(
                                                      color: Colors.grey.shade900,
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                  maxLines: 1
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            ' ${apartment.listingDuration}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ),

                        //Bookmark icon
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: (){},
                                  focusColor: Colors.grey.shade300,
                                  child: const Icon(
                                    DigitalridrAppIcons.bookmark_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                        ),

                      ]
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            )
          ),
          const Divider()
        ],
      ),
    ),
  );
}

Widget listingItem3(BuildContext context, Apartment apartment, int i){
  return GestureDetector(
    onTap: () => travelPage(context,i,apartment),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          //Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //Profile Row
                Row(
                  children: [
                    //Profile Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const AssetImage('assets/images/zenitsu.jpg'),
                    ),
                    const SizedBox(width: 10),
                    //Profile Info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apartment.publishedBy,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          apartment.contact,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.grey.shade500,
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10,),

                // Body
                SizedBox(
                  child: Stack(
                      children: [
                        Hero(
                          tag: 'travel-description-image$i',
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: GridView.count(
                              crossAxisCount: 2,
                              physics: const NeverScrollableScrollPhysics(), // prevent scroll inside
                              childAspectRatio: 1.2, // square images
                              mainAxisSpacing: 0,
                              shrinkWrap: true,
                              crossAxisSpacing: 0,
                              padding: EdgeInsets.zero,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          apartment.images[0],
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
                                          color: Colors.black.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          apartment.images[1],
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
                                          color: Colors.black.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ClipRRect(
                                  borderRadius: BorderRadius.zero,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          apartment.images[1],
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.zero,
                                          color: Colors.black.withValues(alpha: 0.2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Fourth image with overlay
                                ClipRRect(
                                  borderRadius: BorderRadius.zero,
                                  child: SizedBox(
                                    height: 140,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          apartment.images[2],
                                          fit: BoxFit.cover,
                                          height: 140,
                                        ),
                                        Container(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        const Center(
                                          child: Text(
                                            '+4',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Rating
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      apartment.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      )
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Bookmark icon
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: (){},
                                  focusColor: Colors.grey.shade300,
                                  child: const Icon(
                                    DigitalridrAppIcons.bookmark_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                        ),
                      ]
                  ),
                ),
                //description
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withValues(alpha: 0.9),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            apartment.city,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ),
                        //Description
                        Flexible(
                          child: Text(
                            apartment.description,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₦',
                                    style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                    maxLines: 1,
                                  ),
                                  Text(
                                      formatNumToMoney(apartment.price),
                                      style: TextStyle(
                                          color: Colors.grey.shade900,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold
                                      ),
                                      maxLines: 1
                                  ),
                                ],
                              ),
                              const SizedBox(width: 3),
                              Text(
                                ' ${apartment.listingDuration}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2,),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          const Divider()
        ],
      ),
    ),
  );
}

Widget listingItem4(BuildContext context, Apartment apartment, int i, bool isLoading) {
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


int? _lastChoice; // store the last random choice globally or in a class

Widget randomListingItem(
    BuildContext context,
    Apartment apartment,
    int i,
    bool isLoading
    ) {
  final random = Random();
  int choice;

  // keep generating until different from last choice
  do {
    choice = random.nextInt(3); // 0, 1, or 2
  } while (choice == _lastChoice);

  _lastChoice = choice; // update last choice

  switch (choice) {
    case 0:
      return listingItem2(context, apartment, i);
    case 1:
      return listingItem3(context, apartment, i);
    case 2:
      return listingItem4(context, apartment, i, isLoading);
    default:
      return listingItem2(context, apartment, i);
  }
}


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
