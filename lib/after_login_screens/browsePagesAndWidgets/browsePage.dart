import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:MeccaIslamicCenter/after_login_screens/BookDetails/bookDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../APIModels/API_Response.dart';
import '../../Services/API_Services.dart';
import '../../Utilities/showToast.dart';
import '../../before_login_screens/login_screens.dart';
import 'browseBooksWidget.dart';

class Browse extends StatefulWidget {
  const Browse({Key? key}) : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  late TextEditingController searchController;
  bool isAllSelected = false;
  bool isBooksSelected = false;
  bool isAuthorSelected = false;
  bool isPopuplarBooksLoading = false;
  late SecureSharedPref secureSharedPref;
  int userID = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    initPopularBooks(false, -1);
    init();
  }

  bool isBrowseLoading = false;
  init() async {
    setState(() {
      isBrowseLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;

    print(
      'id collected successfully on browse page ' + userID.toString(),
    );
    setState(() {
      isBrowseLoading = false;
    });
  }

  ApiServices get service => GetIt.I<ApiServices>();
  List<PoplarBooksModel> _popularFoundBooks = [];
  late APIResponse<List<PoplarBooksModel>> _responsePopularBooks;
  List<PoplarBooksModel>? popularBooksData;

  initPopularBooks(bool isFromCategory, int catID) async {
    setState(() {
      isPopuplarBooksLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;
    Map dataPopular = {
      "users_customers_id": userID.toString(),
    };
    _responsePopularBooks = await service.getPopularBooks(dataPopular);
    popularBooksData = [];
    _popularFoundBooks = [];
    if (_responsePopularBooks.status!.toLowerCase() == 'success') {
      if (!isFromCategory) {
        popularBooksData = _responsePopularBooks.data;
        _popularFoundBooks = popularBooksData!;
      } else {
        for (PoplarBooksModel model in _responsePopularBooks.data!) {
          if (model.categories_id == catID) {
            popularBooksData!.add(model);
            _popularFoundBooks = popularBooksData!;
          }
        }
      }
    } else {
      showToastError(
        _responsePopularBooks.message,
        FToast().init(context),
      );
    }
    setState(() {
      isPopuplarBooksLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<PoplarBooksModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = popularBooksData!;
    } else {
      results = popularBooksData!
          .where((user) =>
              user.author!.name!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.category!.name!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _popularFoundBooks = results;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            105,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
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
                          0xffF7E683,
                        ),
                        Color(
                          0xffE8B55B,
                        ),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 55.0,
                      bottom: 40,
                      left: 144,
                      right: 20,
                    ),
                    child: Container(
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 159,
                            height: 42,
                            child: Text(
                              'Browse',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xff5B4214,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => logout(context),
                            child:
                                SvgPicture.asset('assets/buttons/logout.svg'),
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                bottom: -30,
                child: SizedBox(
                  width: 343,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        color: Colors.white,
                        child: SizedBox(
                          width: 294,
                          height: 44,
                          child: TextField(
                            // expands: true, maxLines: null,
                            //onTap: () => searchBooksMethod(context),
                            onChanged: (value) => _runFilter(value),
                            controller: searchController,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                            cursorColor: const Color(
                              0xffE8B55B,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                top: 13,
                                bottom: 13,
                              ),
                              hintText: 'Search here',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: const Color(
                                  0xff6C6C6C,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                borderSide: const BorderSide(
                                  color: Color(0xffE8B55B),
                                ),
                              ),
                              border: InputBorder.none,
                              prefixIcon: SvgPicture.asset(
                                'assets/buttons/search_appbar.svg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              width: 266,
                              height: 143,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 92,
                                      height: 27,
                                      child: Text(
                                        'Search By',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Row(
                                      children: [
                                        StatefulBuilder(
                                          builder: (BuildContext context,
                                              void Function(void Function())
                                                  setState) {
                                            return Container(
                                              width: 57,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isAllSelected
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  if (isAllSelected) {
                                                    setState(() {
                                                      isBooksSelected = false;
                                                      isAuthorSelected = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isAllSelected = true;
                                                      isBooksSelected = false;
                                                      isAuthorSelected = false;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'All',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: isAllSelected
                                                        ? const Color(
                                                            0xff00B900,
                                                          )
                                                        : const Color(
                                                            0xff000000,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        StatefulBuilder(
                                          builder: (BuildContext context,
                                              void Function(void Function())
                                                  setState) {
                                            return Container(
                                              width: 57,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isBooksSelected
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  if (isBooksSelected) {
                                                    setState(() {
                                                      isAllSelected = false;
                                                      isAuthorSelected = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isBooksSelected = true;
                                                      isAllSelected = false;
                                                      isAuthorSelected = false;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Books',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: !isBooksSelected
                                                        ? const Color(
                                                            0xff000000,
                                                          )
                                                        : const Color(
                                                            0xff00B900),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        StatefulBuilder(
                                          builder: (BuildContext context,
                                              void Function(void Function())
                                                  setState) {
                                            return Container(
                                              width: 64,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isAuthorSelected
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  if (isAuthorSelected) {
                                                    setState(() {
                                                      isBooksSelected = false;
                                                      isAllSelected = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isAuthorSelected = true;
                                                      isBooksSelected = false;
                                                      isAllSelected = false;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Author',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: !isAuthorSelected
                                                        ? const Color(
                                                            0xff000000,
                                                          )
                                                        : const Color(
                                                            0xff00B900,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Container(
                                      width: 61,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffF7E683),
                                            Color(0xffF7E683),
                                            Color(0xffE8B55B)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          6,
                                        ),
                                      ),
                                      child: TextButton(
                                        style: const ButtonStyle(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'OK',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(
                                              0xff5B4214,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          child: Container(
                            width: 44,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/buttons/search.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: isPopuplarBooksLoading || isBrowseLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffE8B55B),
                ),
              )
            : ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: const Color(0xffE8B55B),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 38,
                    ),
                    child: _popularFoundBooks.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shrinkWrap: true,
                            itemCount: _popularFoundBooks.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 19.0,
                                    mainAxisSpacing: 24.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 310,
                                child: GestureDetector(
                                  onTap: () {
                                    print('browse tapped');
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder: (context) => BookDetails(
                                          popularBooksGetModel:
                                              _popularFoundBooks[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: BrowseBooksWidget(
                                    popularBooksGetModel:
                                        _popularFoundBooks[index],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No resluts found',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }

  logout(BuildContext context) async {
    await secureSharedPref.putString('isLogin', 'false');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogIn()));
  }
}
