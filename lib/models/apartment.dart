import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalridr/models/feature_item.dart';

enum GuestSpace { entireApartment, room, sharedHostel }
enum Status { booked, available, unavailable, reserved }

enum ApartmentTypes {
  studio,
  loft,
  penthouse,
  duplex,
  triplex,
  gardenApartment,
  basementApartment,
  servicedApartment,
  condo,
  coOp,
  townhouse,
  bungalow,
  villa,
  chalet,
  cottage,
  cabin,
  tinyHouse,
  houseboat,
  farmStay,
  guestHouse,
  hostelRoom,
  hotelRoom,
  bedAndBreakfast,
  ryokan,
  riad,
  caveHouse,
  domeHouse,
  yurt,
  treehouse,
  apartmentHotel,
  beachHouse,
  mountainLodge,
  urbanFlat,
  ruralRetreat,
  luxurySuite,
}

class Apartment {
  final String id;
  final String title;
  final String description;
  final int price;
  final List<String> images;
  final String localGovernment;
  final String streetAddress;
  final String city;
  final String country;
  final ApartmentTypes housetype;
  final String houseType;
  final GuestSpace guestSpace;
  final int amountOfAllowedGuest;
  final int amountOfBedRooms;
  final int amountOfBeds;
  final int amountOfBathrooms;
  final List<FeatureItem> features;
  final String publishedBy;
  final Status status;
  final String contact;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String listingDuration;
  final int interestedUsers;
  final int numberOfReviews;
  final int discountPercentage;
  final double rating;

  Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.localGovernment,
    required this.streetAddress,
    required this.city,
    required this.country,
    required this.housetype,
    required this.guestSpace,
    required this.amountOfAllowedGuest,
    required this.amountOfBedRooms,
    required this.amountOfBeds,
    required this.amountOfBathrooms,
    required this.features,
    required this.publishedBy,
    required this.status,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
    required this.listingDuration,
    required this.interestedUsers,
    required this.numberOfReviews,
    required this.discountPercentage,
    required this.rating,
  }) : houseType = getApartmentType(housetype);

  /// Create Apartment object from Firestore document
  factory Apartment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Apartment(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      localGovernment: data['localGovernment'] ?? '',
      streetAddress: data['streetAddress'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      housetype: _parseApartmentType(data['houseType']),
      guestSpace: _parseGuestSpace(data['guestSpace']),
      amountOfAllowedGuest: data['amountOfAllowedGuest'] ?? 0,
      amountOfBedRooms: data['amountOfBedRooms'] ?? 0,
      amountOfBeds: data['amountOfBeds'] ?? 0,
      amountOfBathrooms: data['amountOfBathrooms'] ?? 0,
      features: _parseFeatures(data['features']),
      publishedBy: data['publishedBy'] ?? '',
      status: _parseStatus(data['status']),
      contact: data['contact'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      listingDuration: data['listingDuration'] ?? '',
      interestedUsers: data['interestedUsers'] ?? 0,
      numberOfReviews: data['numberOfReviews'] ?? 0,
      discountPercentage: data['discountPercentage'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }

  /// Convert Apartment object to Firestore data
  Map<String, dynamic> toFirestore() => {
    'title': title,
    'description': description,
    'price': price,
    'images': images,
    'localGovernment': localGovernment,
    'streetAddress': streetAddress,
    'city': city,
    'country': country,
    'houseType': houseType,
    'guestSpace': guestSpace.name,
    'amountOfAllowedGuest': amountOfAllowedGuest,
    'amountOfBedRooms': amountOfBedRooms,
    'amountOfBeds': amountOfBeds,
    'amountOfBathrooms': amountOfBathrooms,
    'features': features.map((f) => f.feature.name).toList(),
    'publishedBy': publishedBy,
    'status': status.name,
    'contact': contact,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
    'listingDuration': listingDuration,
    'interestedUsers': interestedUsers,
    'numberOfReviews': numberOfReviews,
    'discountPercentage': discountPercentage,
    'rating': rating,
  };
}

/// -------- ENUM PARSERS --------

ApartmentTypes _parseApartmentType(String? type) {
  if (type == null) return ApartmentTypes.studio;
  return ApartmentTypes.values.firstWhere(
        (e) => e.name.toLowerCase() == type.toLowerCase(),
    orElse: () => ApartmentTypes.studio,
  );
}

GuestSpace _parseGuestSpace(String? space) {
  switch (space?.toLowerCase()) {
    case 'yes':
    case 'entire apartment':
      return GuestSpace.entireApartment;
    case 'room':
      return GuestSpace.room;
    default:
      return GuestSpace.sharedHostel;
  }
}

Status _parseStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'booked':
      return Status.booked;
    case 'available':
    case 'active':
      return Status.available;
    case 'reserved':
      return Status.reserved;
    default:
      return Status.unavailable;
  }
}

List<FeatureItem> _parseFeatures(dynamic features) {
  if (features == null) return [];
  List<String> featureNames = [];
  if (features is String) {
    featureNames = features.split(',').map((e) => e.trim()).toList();
  } else if (features is List) {
    featureNames = features.map((e) => e.toString().trim()).toList();
  }
  return featureNames.map((name) {
    final match = Feature.values.firstWhere(
          (f) => f.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Feature.Wifi,
    );
    return FeatureItem(feature: match);
  }).toList();
}

String getApartmentType(ApartmentTypes houseType) {
  switch (houseType) {
    case ApartmentTypes.studio:
      return 'Studio Apartment';
    case ApartmentTypes.duplex:
      return 'Duplex';
    case ApartmentTypes.villa:
      return 'Villa';
    case ApartmentTypes.penthouse:
      return 'Penthouse';
    default:
      return 'Apartment';
  }
}
