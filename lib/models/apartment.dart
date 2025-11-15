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
  final String id; // ⬅ Updated to String
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

  // 🔽 FROM JSON
  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['_id']?.toString() ?? '',        // ⬅ Correct field & type
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,

      // ⬅ Cleaned image parser for comma-separated string
      images: _parseImages(json),

      localGovernment: json['localGovernment'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      housetype: _parseApartmentType(json['houseType']),
      guestSpace: _parseGuestSpace(json['guestSpace']),
      amountOfAllowedGuest: json['amountOfAllowedGuest'] ?? 0,
      amountOfBedRooms: json['amountOfBedRooms'] ?? 0,
      amountOfBeds: json['amountOfBeds'] ?? 0,
      amountOfBathrooms: json['amountOfBathrooms'] ?? 0,

      features: _parseFeatures(json['features']),

      publishedBy: json['publishedBy'] ?? '',
      status: _parseStatus(json['status']),
      contact: json['contact'] ?? '',

      // ⬅ Server timestamps
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),

      listingDuration: json['listingDuration'] ?? '',
      interestedUsers: json['interestedUsers'] ?? 0,
      numberOfReviews: json['numberOfReviews'] ?? 0,
      discountPercentage: json['discountPercentage'] ?? 0,

      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 0.0
          : 0.0,
    );
  }

  // 🔼 TO JSON
  Map<String, dynamic> toJson() => {
    '_id': id,
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
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'listingDuration': listingDuration,
    'interestedUsers': interestedUsers,
    'numberOfReviews': numberOfReviews,
    'discountPercentage': discountPercentage,
    'rating': rating,
  };
}

//
// -------- ENUM PARSERS --------
//

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

List<String> _parseImages(Map<String, dynamic> json) {
  final raw = json['image'] ?? json['images'];

  if (raw == null || raw is! String) return [];

  return raw.split(',').map((e) => e.trim()).toList();
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