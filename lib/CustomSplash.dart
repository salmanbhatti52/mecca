import 'package:MeccaIslamicCenter/bottomNavigatorBar.dart';
import 'package:MeccaIslamicCenter/onBoardingScreens.dart';
import 'package:flutter/material.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class CustomSplash extends StatefulWidget {
  const CustomSplash({Key? key}) : super(key: key);

  @override
  State<CustomSplash> createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash> {
  late SecureSharedPref secureSharedPref;
  String isLogin = 'false';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    secureSharedPref = await SecureSharedPref.getInstance();
    isLogin = (await secureSharedPref.getString('isLogin')) ?? 'false';

    Future.delayed(const Duration(seconds: 6), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return isLogin == "true"
            ? const BottomNavigationBarScreens()
            : const OnBoardingScreens();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Splash.png"), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
