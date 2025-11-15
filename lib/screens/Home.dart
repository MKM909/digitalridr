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
import 'package:digitalridr/services/apartment_service.dart';
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

  final ApartmentService apartmentService = ApartmentService();
  late final List<Apartment> apartments;


  @override
  void initState() {
    super.initState();
    loadApartments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadApartments() async {
    try {
      apartments  = await apartmentService.fetchApartments();
      debugPrint('MYAPP: loadApartments -> ${apartments.first.title}');
    } catch (e) {
      debugPrint('MYAPP: loadApartments -> Error: $e');
    }
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
