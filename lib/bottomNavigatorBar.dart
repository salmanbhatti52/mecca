import 'package:MeccaIslamicCenter/after_login_screens/ProfileChangingsScreens/UpdatePasswordAfterLogIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

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

  @override
  Widget build(BuildContext context) {
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  20,
                ),
              ),
            ),
            height: 8.h,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                  20,
                ),
              ),
              child: BottomNavigationBar(
                elevation: 1.0,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icons/home.svg'),
                    activeIcon: SvgPicture.asset('assets/icons/home_green.svg'),
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
                iconSize: 18,
                selectedItemColor: const Color(0xff00B900),
                unselectedItemColor: const Color(
                  0xffADADAD,
                ),
                selectedLabelStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                unselectedLabelStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
