import 'package:digitalridr/core/app_colors.dart';
import 'package:digitalridr/core/app_gradients.dart';
import 'package:digitalridr/custom_icons/digitalridr_app_icons.dart';
import 'package:digitalridr/customui/animated_nav_bar.dart';
import 'package:digitalridr/models/apartment.dart';
import 'package:digitalridr/models/feature_item.dart';
import 'package:digitalridr/screens/ApartmentPage.dart';
import 'package:digitalridr/screens/DetailsPage.dart';
import 'package:digitalridr/screens/HomePage.dart';
import 'package:digitalridr/screens/SearchPage.dart';
import 'package:digitalridr/screens/SettingsPage.dart';
import 'package:digitalridr/tools/fetchApartments.dart';
import 'package:digitalridr/tools/hexToColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    loadApartments();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    ));
    AppColors.setContext(context);
    AppGradients.setContext(context);

    final List<Widget> btTabPages = [
      const HomePage(),
      const ApartmentPage(),
      const SearchPage(),
      const SettingsScreen(),
    ];

    final List<IconData> icons = [
      DigitalridrAppIcons.home,
      DigitalridrAppIcons.apartment_1,
      DigitalridrAppIcons.bookmark_filled,
      DigitalridrAppIcons.chats,
    ];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: btTabPages[selectedIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedNavBar(
                icons: icons,
                currentIndex: selectedIndex,
                onItemSelected: (index){
                  setState(() {
                    selectedIndex = index;
                  });
                },
            ),
          )
        ],
      ),
      backgroundColor: hexToColor('#ffffff'),
    );

  }
}

void loadApartments() async {
  try {
    final
    List<Apartment> apartments  = await fetchApartments();
    debugPrint('MYAPP: loadApartments -> ${apartments.first.title}');
  } catch (e) {
    debugPrint('MYAPP: loadApartments -> Error: $e');
  }
}


List<Apartment> apartments = [
  Apartment(
    id: "0",
    title: "Aba Ventures",
    description:
    "Imagine standing on a beach, where the golden sand stretches out beneath your feet, warm from the sun’s rays. The gentle ebb and flow of the waves create a soothing rhythm, their sound mingling with the distant cries of seagulls.",
    price: 100000,
    images: [
      "assets/images/apartment3.webp",
      "assets/images/apartment6.webp",
      "assets/images/apartment1.webp",
      "assets/images/apartment9.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "Lekki",
    streetAddress: "19, Odutuga Street",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.luxurySuite,
    guestSpace: GuestSpace.room,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.ExerciseEquipment),
    ],
    publishedBy: "Micah Okoh",
    status: Status.available,
    contact: "09126433601",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Week",
    interestedUsers: 100,
    numberOfReviews: 10,
    discountPercentage: 5,
    rating: 3.5,
  ),

  Apartment(
    id: "1",
    title: "Ikeja Skyline Apartment",
    description:
    "A cozy urban retreat overlooking Ikeja’s vibrant skyline. Perfect for travelers seeking comfort and city convenience.",
    price: 85000,
    images: [
      "assets/images/apartment1.webp",
      "assets/images/apartment5.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "Ikeja",
    streetAddress: "12, Allen Avenue",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.studio,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.Tv),
      FeatureItem(feature: Feature.Kitchen),
    ],
    publishedBy: "Grace Udoh",
    status: Status.available,
    contact: "09034781234",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "2 Weeks",
    interestedUsers: 45,
    numberOfReviews: 6,
    discountPercentage: 10,
    rating: 4.2,
  ),

  Apartment(
    id: "2",
    title: "Victoria Island Waterfront",
    description:
    "Experience luxury at its finest with an ocean-view penthouse. Enjoy sunsets from your private balcony.",
    price: 250000,
    images: [
      "assets/images/apartment7.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment9.webp",
      "assets/images/apartment10.webp",
    ],
    localGovernment: "Victoria Island",
    streetAddress: "23, Ajose Adeogun Street",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.penthouse,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.HotTub),
      FeatureItem(feature: Feature.FirstAidKit),
    ],
    publishedBy: "Zainab Lawal",
    status: Status.available,
    contact: "08029876543",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 220,
    numberOfReviews: 38,
    discountPercentage: 15,
    rating: 4.8,
  ),

  Apartment(
    id: "3",
    title: "Lekki Garden Loft",
    description:
    "Modern loft-style apartment with greenery views and contemporary design elements.",
    price: 120000,
    images: [
      "assets/images/apartment2.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment6.webp",
    ],
    localGovernment: "Lekki Phase 1",
    streetAddress: "14, Admiralty Way",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.loft,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 3,
    amountOfBedRooms: 1,
    amountOfBeds: 2,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.Tv),
      FeatureItem(feature: Feature.Patio),
      FeatureItem(feature: Feature.FreeParking),
    ],
    publishedBy: "Damilare Ojo",
    status: Status.available,
    contact: "08122334455",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "3 Weeks",
    interestedUsers: 60,
    numberOfReviews: 9,
    discountPercentage: 0,
    rating: 4.1,
  ),

  Apartment(
    id: "4",
    title: "Banana Island Retreat",
    description:
    "Luxury meets tranquility in this exclusive Banana Island home. Perfect for executives and celebrities.",
    price: 400000,
    images: [
      "assets/images/apartment10.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment9.webp",
    ],
    localGovernment: "Ikoyi",
    streetAddress: "5, Banana Island Road",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.villa,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 6,
    amountOfBedRooms: 4,
    amountOfBeds: 4,
    amountOfBathrooms: 4,
    features: [
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.FireExtinguiser),
    ],
    publishedBy: "Chukwuemeka Ofor",
    status: Status.available,
    contact: "07055667788",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 310,
    numberOfReviews: 42,
    discountPercentage: 5,
    rating: 4.9,
  ),

  Apartment(
    id: "5",
    title: "Surulere Comfort Suite",
    description:
    "A bright, modern suite with a cozy interior and quick access to the city center.",
    price: 70000,
    images: [
      "assets/images/apartment5.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "Surulere",
    streetAddress: "8, Bode Thomas Street",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.studio,
    guestSpace: GuestSpace.room,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.FirstAidKit),
    ],
    publishedBy: "Aisha Bello",
    status: Status.available,
    contact: "08190901234",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Week",
    interestedUsers: 30,
    numberOfReviews: 4,
    discountPercentage: 5,
    rating: 4.0,
  ),

  Apartment(
    id: "6",
    title: "Abuja Hillside Villa",
    description:
    "Experience serenity at this hillside villa overlooking the Abuja skyline.",
    price: 300000,
    images: [
      "assets/images/apartment5.webp",
      "assets/images/apartment6.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment10.webp",
    ],
    localGovernment: "Maitama",
    streetAddress: "9, Ibrahim Babangida Boulevard",
    city: "Abuja",
    country: "Nigeria",
    housetype: ApartmentTypes.villa,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 5,
    amountOfBedRooms: 3,
    amountOfBeds: 3,
    amountOfBathrooms: 3,
    features: [
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.HotTub),
      FeatureItem(feature: Feature.OutdoorDining),
      FeatureItem(feature: Feature.Firepit),
    ],
    publishedBy: "Sarah Johnson",
    status: Status.available,
    contact: "08076543210",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "2 Months",
    interestedUsers: 190,
    numberOfReviews: 25,
    discountPercentage: 10,
    rating: 4.7,
  ),

  Apartment(
    id: "7",
    title: "Yaba Tech Loft",
    description:
    "A tech-inspired loft close to Yaba’s innovation hub. Great for young professionals.",
    price: 95000,
    images: [
      "assets/images/apartment1.webp",
      "assets/images/apartment2.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment9.webp",
    ],
    localGovernment: "Yaba",
    streetAddress: "17, Herbert Macaulay Way",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.loft,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.DedicatedWorkspace),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.SmokeAlarm),
    ],
    publishedBy: "Tope Adebayo",
    status: Status.available,
    contact: "07099887766",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "3 Weeks",
    interestedUsers: 75,
    numberOfReviews: 10,
    discountPercentage: 8,
    rating: 4.3,
  ),

  Apartment(
    id: "8",
    title: "Enugu Mountain Lodge",
    description:
    "Enjoy breathtaking mountain views in this cozy lodge located near the hills of Enugu.",
    price: 180000,
    images: [
      "assets/images/apartment7.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment5.webp",
    ],
    localGovernment: "Ngwo",
    streetAddress: "21, Ogbete Hills Road",
    city: "Enugu",
    country: "Nigeria",
    housetype: ApartmentTypes.chalet,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 2,
    amountOfBeds: 3,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Firepit),
      FeatureItem(feature: Feature.Patio),
      FeatureItem(feature: Feature.BBQgrill),
    ],
    publishedBy: "John Obi",
    status: Status.available,
    contact: "08134567789",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 150,
    numberOfReviews: 22,
    discountPercentage: 12,
    rating: 4.6,
  ),

  Apartment(
    id: "9",
    title: "Port Harcourt Riverfront Condo",
    description:
    "Relax beside the calm rivers of Port Harcourt in this waterfront condo.",
    price: 210000,
    images: [
      "assets/images/apartment8.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment10.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "GRA Phase 2",
    streetAddress: "5, Ebitimi Banigo Street",
    city: "Port Harcourt",
    country: "Nigeria",
    housetype: ApartmentTypes.condo,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 3,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.FreeParking),
      FeatureItem(feature: Feature.FirstAidKit),
    ],
    publishedBy: "Blessing Nwoko",
    status: Status.available,
    contact: "07099883322",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "2 Months",
    interestedUsers: 130,
    numberOfReviews: 18,
    discountPercentage: 10,
    rating: 4.4,
  ),

  // 👇 Continue from id: 10 to 19 below
  Apartment(
    id: "10",
    title: "Osapa London Duplex",
    description:
    "A stylish duplex apartment in the heart of Osapa, featuring smart-home controls and modern interiors.",
    price: 160000,
    images: [
      "assets/images/apartment3.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment9.webp",
    ],
    localGovernment: "Lekki",
    streetAddress: "44, Osapa London Crescent",
    city: "Lagos",
    country: "Nigeria",
    housetype: ApartmentTypes.duplex,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 3,
    amountOfBeds: 3,
    amountOfBathrooms: 3,
    features: [
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Tv),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.SmokeAlarm),
    ],
    publishedBy: "Oluwatobi Ajayi",
    status: Status.available,
    contact: "07055522117",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 95,
    numberOfReviews: 14,
    discountPercentage: 7,
    rating: 4.3,
  ),

  Apartment(
    id: "11",
    title: "Asokoro Executive Suite",
    description:
    "Enjoy state-of-the-art amenities in this luxurious Asokoro executive suite. Ideal for diplomats and business travelers.",
    price: 350000,
    images: [
      "assets/images/apartment10.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment6.webp",
    ],
    localGovernment: "Asokoro",
    streetAddress: "3, Nnamdi Azikiwe Drive",
    city: "Abuja",
    country: "Nigeria",
    housetype: ApartmentTypes.luxurySuite,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.FirstAidKit),
    ],
    publishedBy: "Chinenye Eze",
    status: Status.available,
    contact: "08032147761",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "2 Weeks",
    interestedUsers: 300,
    numberOfReviews: 33,
    discountPercentage: 10,
    rating: 4.9,
  ),

  Apartment(
    id: "12",
    title: "Ibadan Garden Bungalow",
    description:
    "A peaceful bungalow surrounded by lush gardens — perfect for family vacations or solo retreats.",
    price: 95000,
    images: [
      "assets/images/apartment1.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment5.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "Bodija",
    streetAddress: "12, Adeoyo Street",
    city: "Ibadan",
    country: "Nigeria",
    housetype: ApartmentTypes.bungalow,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 3,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.FreeParking),
      FeatureItem(feature: Feature.Patio),
      FeatureItem(feature: Feature.Kitchen),
    ],
    publishedBy: "Segun Adewale",
    status: Status.available,
    contact: "08121213334",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "3 Weeks",
    interestedUsers: 40,
    numberOfReviews: 5,
    discountPercentage: 8,
    rating: 4.1,
  ),

  Apartment(
    id: "13",
    title: "Abeokuta Heritage Cottage",
    description:
    "Experience the rustic charm of Abeokuta in this cozy heritage cottage near Olumo Rock.",
    price: 60000,
    images: [
      "assets/images/apartment6.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment9.webp",
    ],
    localGovernment: "Abeokuta South",
    streetAddress: "7, Itoku Street",
    city: "Abeokuta",
    country: "Nigeria",
    housetype: ApartmentTypes.cottage,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.Firepit),
      FeatureItem(feature: Feature.SmokeAlarm),
    ],
    publishedBy: "Funmi Alabi",
    status: Status.available,
    contact: "08065654321",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 60,
    numberOfReviews: 8,
    discountPercentage: 5,
    rating: 4.0,
  ),

  Apartment(
    id: "14",
    title: "Jos Plateau Chalet",
    description:
    "A scenic mountain-side chalet offering cool weather, fire pits, and a panoramic view of the Jos Plateau.",
    price: 130000,
    images: [
      "assets/images/apartment7.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment9.webp",
      "assets/images/apartment10.webp",
    ],
    localGovernment: "Rayfield",
    streetAddress: "18, Plateau Drive",
    city: "Jos",
    country: "Nigeria",
    housetype: ApartmentTypes.chalet,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Firepit),
      FeatureItem(feature: Feature.PoolTable),
      FeatureItem(feature: Feature.FreeParking),
    ],
    publishedBy: "Boma Daniel",
    status: Status.available,
    contact: "09054329876",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 100,
    numberOfReviews: 12,
    discountPercentage: 0,
    rating: 4.4,
  ),

  Apartment(
    id: "15",
    title: "Calabar Beachfront Apartment",
    description:
    "Wake up to ocean views and sea breeze in this vibrant Calabar beachfront apartment.",
    price: 200000,
    images: [
      "assets/images/apartment5.webp",
      "assets/images/apartment8.webp",
      "assets/images/apartment7.webp",
      "assets/images/apartment2.webp",
    ],
    localGovernment: "Marina",
    streetAddress: "4, Bishop Moynagh Avenue",
    city: "Calabar",
    country: "Nigeria",
    housetype: ApartmentTypes.beachHouse,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 4,
    amountOfBedRooms: 2,
    amountOfBeds: 3,
    amountOfBathrooms: 2,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.BeachAccess),
      FeatureItem(feature: Feature.OutdoorDining),
    ],
    publishedBy: "Peace Etim",
    status: Status.available,
    contact: "08126665432",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 210,
    numberOfReviews: 28,
    discountPercentage: 12,
    rating: 4.7,
  ),

  Apartment(
    id: "16",
    title: "Ilorin Cozy Condo",
    description:
    "Affordable and comfortable condo in Ilorin, perfect for couples and short business stays.",
    price: 75000,
    images: [
      "assets/images/apartment1.webp",
      "assets/images/apartment5.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment6.webp",
    ],
    localGovernment: "Tanke",
    streetAddress: "27, University Road",
    city: "Ilorin",
    country: "Nigeria",
    housetype: ApartmentTypes.condo,
    guestSpace: GuestSpace.room,
    amountOfAllowedGuest: 2,
    amountOfBedRooms: 1,
    amountOfBeds: 1,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.Tv),
    ],
    publishedBy: "David Kayode",
    status: Status.available,
    contact: "07023213456",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "3 Weeks",
    interestedUsers: 55,
    numberOfReviews: 7,
    discountPercentage: 5,
    rating: 4.2,
  ),

  Apartment(
    id: "17",
    title: "Owerri Central Apartment",
    description:
    "Centrally located apartment with easy access to major roads and entertainment centers.",
    price: 110000,
    images: [
      "assets/images/apartment8.webp",
      "assets/images/apartment5.webp",
      "assets/images/apartment10.webp",
      "assets/images/apartment4.webp",
    ],
    localGovernment: "Owerri Municipal",
    streetAddress: "15, Douglas Road",
    city: "Owerri",
    country: "Nigeria",
    housetype: ApartmentTypes.urbanFlat,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 3,
    amountOfBedRooms: 2,
    amountOfBeds: 2,
    amountOfBathrooms: 1,
    features: [
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.Wifi),
      FeatureItem(feature: Feature.SmokeAlarm),
    ],
    publishedBy: "Rita Okeke",
    status: Status.available,
    contact: "08122233445",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "2 Weeks",
    interestedUsers: 80,
    numberOfReviews: 9,
    discountPercentage: 6,
    rating: 4.3,
  ),

  Apartment(
    id: "18",
    title: "Kaduna Family Duplex",
    description:
    "Spacious duplex with large living space and backyard, ideal for family holidays.",
    price: 140000,
    images: [
      "assets/images/apartment9.webp",
      "assets/images/apartment10.webp",
      "assets/images/apartment3.webp",
      "assets/images/apartment1.webp",
    ],
    localGovernment: "Barnawa",
    streetAddress: "22, Ungwan Rimi Street",
    city: "Kaduna",
    country: "Nigeria",
    housetype: ApartmentTypes.duplex,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 6,
    amountOfBedRooms: 3,
    amountOfBeds: 4,
    amountOfBathrooms: 3,
    features: [
      FeatureItem(feature: Feature.FreeParking),
      FeatureItem(feature: Feature.Kitchen),
      FeatureItem(feature: Feature.FirstAidKit),
    ],
    publishedBy: "Halima Mohammed",
    status: Status.available,
    contact: "09012347890",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 120,
    numberOfReviews: 15,
    discountPercentage: 10,
    rating: 4.5,
  ),

  Apartment(
    id: "19",
    title: "Uyo Palm Villa",
    description:
    "Modern villa surrounded by palm trees, offering privacy and luxury with tropical vibes.",
    price: 275000,
    images: [
      "assets/images/apartment2.webp",
      "assets/images/apartment4.webp",
      "assets/images/apartment6.webp",
      "assets/images/apartment8.webp",
    ],
    localGovernment: "Ewet Housing",
    streetAddress: "9, Palm Crescent Avenue",
    city: "Uyo",
    country: "Nigeria",
    housetype: ApartmentTypes.villa,
    guestSpace: GuestSpace.entireApartment,
    amountOfAllowedGuest: 5,
    amountOfBedRooms: 3,
    amountOfBeds: 3,
    amountOfBathrooms: 3,
    features: [
      FeatureItem(feature: Feature.Pool),
      FeatureItem(feature: Feature.AirConditioning),
      FeatureItem(feature: Feature.BBQgrill),
      FeatureItem(feature: Feature.Patio),
    ],
    publishedBy: "Iniobong Udo",
    status: Status.available,
    contact: "08090904567",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    listingDuration: "1 Month",
    interestedUsers: 180,
    numberOfReviews: 20,
    discountPercentage: 10,
    rating: 4.8,
  ),
];



// Code For Slowing Down Hero Animation
class SlowMaterialPageRoute<T> extends MaterialPageRoute<T> {
  SlowMaterialPageRoute({required super.builder});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600); // Adjust as needed
}

void travelPage(BuildContext context,int i, Apartment apartment){
  Navigator.of(context).push(
      SlowMaterialPageRoute(
          builder: (context) => DetailsPage(i: i, apartment: apartment,)
      )
  );
}
