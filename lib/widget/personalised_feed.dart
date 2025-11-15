import 'package:carousel_slider/carousel_controller.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:digitalridr/screens/Home.dart';
import 'package:digitalridr/services/apartment_service.dart';
import 'package:digitalridr/widget/listing_items.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PersonalisedFeed extends StatelessWidget {
  final ApartmentService apartmentService = ApartmentService();
  final bool isLoading;

  PersonalisedFeed({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: apartmentService.getUniqueCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 200,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No cities found'));
        }

        final cities = snapshot.data!;

        return Column(
          children: cities.map((city) {
            return FutureBuilder<List<Apartment>>(
              future: apartmentService.getApartmentsByCity(city),
              builder: (context, citySnapshot) {
                if (citySnapshot.connectionState == ConnectionState.waiting) {
                  return listingItem4Shimmering(context);
                } else if (citySnapshot.hasError) {
                  return Text('Error loading apartments for $city: ${citySnapshot.error}');
                } else if (!citySnapshot.hasData || citySnapshot.data!.isEmpty) {
                  return const SizedBox.shrink(); // skip empty cities
                }

                final apartments = citySnapshot.data!;

                return Column(
                  children: List.generate(apartments.length, (index) {
                    final apartment = apartments[index];
                    return listingItem4(context, apartment, index, isLoading, apartments);
                  }),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
