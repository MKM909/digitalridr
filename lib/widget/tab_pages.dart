import 'package:carousel_slider/carousel_controller.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:digitalridr/screens/Home.dart';
import 'package:digitalridr/widget/listing_items.dart';
import 'package:flutter/material.dart';

Widget personalisedFeedList(BuildContext context, bool isLoading) {
  return Column(
    children: List.generate(apartments.length, (i) {
      final apartment = apartments[i];
      return Column(
        children: [
          listingItem4(context, apartment, i, isLoading),
          // Optional: if you still want another section
          // randomListingItem(context, apartment, i),
        ],
      );
    }),
  );
}


Widget filteredFeed(BuildContext context){
  return Padding(
    padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 0),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: apartments.length,
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of columns
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // adjust for card height/width balance
      ),
      itemBuilder: (context, index) {
        return unboundedListingItem(context, apartments[index], index);
      },
    ),
  );
}