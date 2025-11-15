import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:digitalridr/models/apartment.dart';

Future<List<Apartment>> fetchApartments() async {
  final response = await http.get(
    Uri.parse('https://express-alpha-seven.vercel.app/api/apartments'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => Apartment.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load apartments');
  }
}
// 🔹 Get unique list of cities from all apartments
List<String> getUniqueCities(List<Apartment> apartments) {
  final cities = <String>{}; // Set = prevents duplicates automatically

  for (final apartment in apartments) {
    if (apartment.city.isNotEmpty) {
      cities.add(apartment.city.trim());
    }
  }

  return cities.toList();
}

// 🔹 Get all apartments located in a specific city
List<Apartment> getApartmentsByCity(
    List<Apartment> apartments,
    String city,
    ) {
  return apartments
      .where((apt) => apt.city.toLowerCase().trim() == city.toLowerCase().trim())
      .toList();
}
