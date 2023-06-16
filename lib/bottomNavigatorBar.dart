import 'package:MeccaIslamicCenter/after_login_screens/ProfileChangingsScreens/UpdatePasswordAfterLogIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'after_login_screens/bookMarkPagesWidgets/bookMark.dart';
import 'after_login_screens/browsePagesAndWidgets/browsePage.dart';
import 'after_login_screens/homePageScreensAndWidgets/homePage.dart';

class BottomNavigationBarScreens extends StatefulWidget {
  const BottomNavigationBarScreens({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreens> createState() =>
      _BottomNavigationBarScreensState();
}

class _BottomNavigationBarScreensState
    extends State<BottomNavigationBarScreens> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  // late TextEditingController searchController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   searchController = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   searchController.dispose();
  // }

  final List _pages = [
    const HomePage(),
    const Browse(),
    const BookMark(),
    const UpdatePassword(),
  ];

  int _currentIndex = 0;

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool get isIos =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  @override
  Widget build(BuildContext context) {
    if (isIos) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            currentIndex: _currentIndex,
            height: 75.h,
            iconSize: 18.sp,
            inactiveColor: const Color(
              0xffADADAD,
            ),
            activeColor: const Color(0xff00B900),
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home.svg'),
                activeIcon: SvgPicture.asset('assets/icons/home_green.svg'),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/search.svg'),
                activeIcon: SvgPicture.asset('assets/icons/search_green.svg'),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/bookmark.svg'),
                activeIcon: SvgPicture.asset('assets/icons/bookmark_green.svg'),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/profile_grey.svg'),
                activeIcon: SvgPicture.asset('assets/icons/profile_green.svg'),
                label: 'Profile',
              ),
            ],
            onTap: onTap,
          ),
          tabBuilder: (context, index) {
            return CupertinoTabView(
              builder: (context) {
                return _pages[_currentIndex];
              },
            );
          });
    } else {
      return WillPopScope(
        onWillPop: () async {
          if (_currentIndex == 0) {
            return true;
          } else {
            setState(() {
              _currentIndex = 0;
            });
          }
          return false;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            key: key,
            body: _pages[_currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    20.r,
                  ),
                ),
              ),
              height: 75.h,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    20.r,
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 1.0,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/home.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/icons/home_green.svg'),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/search.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/icons/search_green.svg'),
                      label: 'Browse',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/bookmark.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/icons/bookmark_green.svg'),
                      label: 'Bookmark',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/profile_grey.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/icons/profile_green.svg'),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _currentIndex,
                  onTap: onTap,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                  iconSize: 18.sp,
                  selectedItemColor: const Color(0xff00B900),
                  unselectedItemColor: const Color(
                    0xffADADAD,
                  ),
                  selectedLabelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                  unselectedLabelStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
