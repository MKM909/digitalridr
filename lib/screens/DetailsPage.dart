import 'dart:ui';

import 'package:digitalridr/custom_icons/digitalridr_app_icons.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:digitalridr/tools/formatNumToMoney.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DetailsPage extends StatefulWidget {

  final int i;
  final Apartment apartment;
  
  const DetailsPage({super.key, required this.i, required this.apartment});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  final ScrollController _scrollController = ScrollController();
  bool _actionTriggered = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // Only trigger once when crossing thresholds
      if (!_actionTriggered && _scrollController.offset >= 200) {
        setState(() => _actionTriggered = true);
      } else if (_actionTriggered && _scrollController.offset < 200) {
        setState(() => _actionTriggered = false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 🏞️ Top image section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.apartment.images.length,
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    widget.apartment.images[index],
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                },
                              ),
                            ),
                          ),

                          // Rating badge
                          Positioned(
                            bottom: 30,
                            left: 30,
                            child: _glassContainer(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${widget.apartment.rating}",
                                    style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  )),
                                  const SizedBox(width: 3),
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                                ],
                              ),
                            ),
                          ),

                          // Bookmark
                          Positioned(
                              bottom: 30,
                              right: 30,
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
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),

                      // 🏠 Apartment Details
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.apartment.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Chips row (you can wrap it in a SingleChildScrollView horizontally if needed)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                _infoChip('${widget.apartment.amountOfBathrooms} Bathrooms'),
                                _infoChip('${widget.apartment.amountOfBedRooms} Bedrooms'),
                                _infoChip('${widget.apartment.amountOfAllowedGuest} Guests'),
                                _infoChip(getSpaceType(widget.apartment.guestSpace)),
                                _infoChip('${widget.apartment.amountOfBeds} Beds'),
                              ],
                            ),

                            const SizedBox(height: 10,),

                            ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  child: InkWell(
                                    onTap: (){},
                                    focusColor: Colors.grey.shade200,
                                    child: SizedBox(
                                      height: 65,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(widget.apartment.numberOfReviews.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16)),
                                                const Text("Reviews",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          Container(width: 1, height: 55, color: Colors.grey),
                                          const SizedBox(width: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/laurel_wreath_left.png', height: 50),
                                              const SizedBox(width: 4),
                                              const Text("Guest's\nFavourite",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 13)),
                                              const SizedBox(width: 4),
                                              Image.asset('assets/images/laurel_wreath_right.png', height: 50),
                                            ],
                                          ),
                                          const SizedBox(width: 15,),
                                          Container(width: 1, height: 55, color: Colors.grey),
                                          const SizedBox(width: 15,),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(formatNumToMoney(widget.apartment.price),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16)),
                                                Text(widget.apartment.listingDuration,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),

                            const SizedBox(height: 10),

                            const Divider(),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/zenitsu.jpg'),
                                  radius: 23,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hosted by ${widget.apartment.publishedBy}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      '3 years hosting experience',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            const Divider(),

                            const SizedBox(height: 10),

                            Text(
                              widget.apartment.description,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),

                            const SizedBox(height: 10,),

                            const Divider(),

                            const SizedBox(height: 10,),

                            // Where you'll sleep heading

                            const Row(
                              children: [
                                Text(
                                  "Where you'll sleep",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10,),

                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      splashColor: Colors.grey.shade300,
                                      child: Container(
                                        width: 110,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                            style: BorderStyle.solid
                                          )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.bed_outlined,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            const SizedBox(height: 5,),
                                            const Text(
                                              "Bedroom",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(
                                              "${widget.apartment.amountOfBedRooms} Bed",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey.shade600,
                                              ),
                                            ),

                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10,),

                            const Divider(),

                            const SizedBox(height: 10,),

                            const Row(
                              children: [
                                Text(
                                  "What this place offers",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.apartment.features.length,
                                padding: const EdgeInsets.only(top: 10),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      child: InkWell(
                                        onTap: () {},
                                        splashColor: Colors.grey.shade300,
                                        child: Container(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                widget.apartment.features[index].iconData,
                                                size: 22,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                widget.apartment.features[index].feature.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),


                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            //Back Button
            Positioned(
              top: 40,
              left: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child:  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35), // semi-transparent glass
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), style: BorderStyle.solid, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        )
                      ]
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Icon(CupertinoIcons.back, color: Colors.black, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            // Image List Preview
            Positioned(
              top: 40,
              right: 30,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (child, animation) => FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axisAlignment: -1,
                              child: child,
                            ),
                          ),
                          child: _actionTriggered
                              ? CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 22,
                            child: Center(
                              child: Text(
                                "+${widget.apartment.images.length - 2}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                              : Column(
                            key: const ValueKey('expanded'),
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                AssetImage(widget.apartment.images[2]),
                                radius: 22,
                              ),
                              const SizedBox(height: 10),
                              CircleAvatar(
                                backgroundImage:
                                AssetImage(widget.apartment.images[3]),
                                radius: 22,
                              ),
                              const SizedBox(height: 10),
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 22,
                                child: Center(
                                  child: Text(
                                    "+${widget.apartment.images.length - 2}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 25, right: 25,top: 15,bottom: 20),
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₦',
                              style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              formatNumToMoney(widget.apartment.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2,),
                        Text(
                          'For ${widget.apartment.listingDuration} - 17-19 Apr',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: Colors.grey.shade700
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 15,
                              ),
                              SizedBox(width: 3,),
                              Text(
                                'Free cancellation',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.orangeAccent,
                          child: InkWell(
                            onTap: () {},
                            focusColor: Colors.blue,
                            splashColor: Colors.blue,
                            hoverColor: Colors.blue,
                            highlightColor: Colors.blue,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 15),
                                child: Center(
                                  child: Text(
                                    'Reserve',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 18,
                                        fontFamily: 'Poppins',
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5), style: BorderStyle.solid, width: 1),
            boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          focusColor: Colors.grey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.grey.shade900),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontFamily: 'Poppins',
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getSpaceType(GuestSpace g){
    String space;

    switch(g.name){
      case "entireApartment" :
        space = "Entire Apartment";
        break;
      case "room" :
        space = "A Room";
        break;
      case "sharedHostel" :
        space = "A Shared Hostel";
        break;
      default :
        space = "Entire Apartment";

    }

    return space;
  }

}
