import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;

  const NetworkAwareWidget({super.key, required this.child});

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List <ConnectivityResult> result) async {
      bool hasInternet = await _hasInternet();
      setState(() {
        _isOffline = !hasInternet;
      });
    });
  }

  Future<void> _checkInitialConnection() async {
    bool hasInternet = await _hasInternet();
    setState(() {
      _isOffline = !hasInternet;
    });
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('https://www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontScale = screenWidth / 350;

    return Container(
      child: _isOffline
          ? Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset(
                          'assets/lottie/no_internet_connection.json',
                          width: screenWidth - 65,
                          repeat: false,
                          animate: true,
                          ),
                        ),
                        SizedBox(height: 15 * fontScale, width: 15 * fontScale),
                        Text(
                          'No internet connection',
                          style: TextStyle(
                            fontSize: 15 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins'
                          ),
                          textAlign: TextAlign.center,
                        )
                    ]
                  ),
          )
          : widget.child,
    );
  }
}
