import 'dart:io';

import 'package:MeccaIslamicCenter/CustomSplash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'Services/API_Services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Future.delayed(const Duration(seconds: 5));
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(MyApp()); // Wrap your app);
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => MyApp(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    if (!GetIt.I.isRegistered<ApiServices>()) {
      GetIt.I.registerLazySingleton(() => ApiServices());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'MeccaIslamicCentre',
        debugShowCheckedModeBanner: false,
        home: CustomSplash(),
        // home: AnimatedSplashScreen(
        //   duration: 3000,
        //   splash: 'assets/images/Splash.png',
        //   nextScreen: OnBoardingScreens(),
        //   splashTransition: SplashTransition.fadeTransition,
        //   //pageTransitionType: PageTransitionType.scale,
        //   //backgroundColor: Colors.blue,
        // ),
      );
    });
  }
}
