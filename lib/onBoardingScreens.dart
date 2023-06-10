import 'package:MeccaIslamicCenter/before_login_screens/login_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 35.h),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  // stops: [
                  //   0.72,
                  //   0.31,
                  //   0.03,
                  // ],
                  colors: [
                    Color(
                      0xffF7E683,
                    ),
                    Color(
                      0xffE8B55B,
                    ),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: 50.h,
                    ),
                  ),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/images/onboard2.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      SvgPicture.asset(
                        'assets/images/onboard22.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  SvgPicture.asset('assets/images/onboard2_text.svg'),
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LogIn(),
                        ),
                      ),
                      child: SvgPicture.asset(
                          'assets/buttons/onboard_forward.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
