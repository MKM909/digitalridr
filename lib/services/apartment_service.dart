import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:flutter/cupertino.dart';

class ApartmentService {
  final CollectionReference apartmentsCollection =
  FirebaseFirestore.instance.collection('apartments');

  /// 🔹 Fetch all apartments
  Future<List<Apartment>> fetchApartments() async {
    try {
      final querySnapshot = await apartmentsCollection.get();
      debugPrint("MYAPP : fetchApartments -> Apartments fetched successfully");
      return querySnapshot.docs
          .map((doc) => Apartment.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint("MYAPP : fetchApartments -> Error loading apartments: $e");
      throw Exception('Failed to load apartments: $e');
    }
  }

  /// 🔹 Get unique list of cities
  Future<List<String>> getUniqueCities() async {
    try {
      final apartments = await fetchApartments();
      final cities = apartments.map((a) => a.city).toSet().toList();
      cities.sort();
      debugPrint("MYAPP : getUniqueCities -> Unique cities fetched successfully");
      return cities;
    } catch (e) {
      debugPrint("MYAPP : getUniqueCities -> Error fetching unique cities: $e");
      throw Exception('Failed to fetch unique cities: $e');
    }
  }

  /// 🔹 Get apartments by city
  Future<List<Apartment>> getApartmentsByCity(String cityName) async {
    try {
      final querySnapshot = await apartmentsCollection
          .where('city', isEqualTo: cityName)
          .get();
      debugPrint("MYAPP : getApartmentsByCity -> Apartments fetched successfully");
      return querySnapshot.docs
          .map((doc) => Apartment.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint("MYAPP : getApartmentsByCity -> Error fetching apartments: $e");
      throw Exception('Failed to fetch apartments for city $cityName: $e');
    }
  }

  /// 🔹 Add a new apartment
  Future<void> addApartment(Apartment apartment) async {
    try {
      await apartmentsCollection.add(apartment.toFirestore());
      debugPrint("MYAPP : addApartment -> Apartment added successfully");
    } catch (e) {
      debugPrint("MYAPP : addApartment -> Error adding apartment: $e");
      throw Exception('Failed to add apartment: $e');
    }
  }

  /// 🔹 Delete an apartment by ID
  Future<void> deleteApartment(String apartmentId) async {
    try {
      final docRef = apartmentsCollection.doc(apartmentId);
      await docRef.delete();
      debugPrint("MYAPP : deleteApartment -> Apartment deleted successfully");
    } catch (e) {
      debugPrint("MYAPP : deleteApartment -> Error deleting apartment: $e");
      throw Exception('Failed to delete apartment: $e');
    }
  }

  /// 🔹 Update an existing apartment
  Future<void> updateApartment(Apartment apartment) async {
    try {
      final docRef = apartmentsCollection.doc(apartment.id);
      await docRef.update(apartment.toFirestore());
      debugPrint("MYAPP : updateApartment -> Apartment updated successfully");
    } catch (e) {
      debugPrint("MYAPP : updateApartment -> Error updating apartment: $e");
      throw Exception('Failed to update apartment: $e');
    }
  }
}
