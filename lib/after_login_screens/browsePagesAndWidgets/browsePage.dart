import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:MeccaIslamicCenter/after_login_screens/BookDetails/bookDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../APIModels/API_Response.dart';
import '../../APIModels/book_view.dart';
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
  bool isAddingBook = false;
  int indexOfSelectedBook = -1;
  int isSelectedButton = 0;
  bool isPopuplarBooksLoading = false;
  late SecureSharedPref secureSharedPref;
  int userID = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    initPopularBooks(
      false,
      -1,
    );
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

  initPopularBooks(
    bool isFromCategory,
    int catID,
  ) async {
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

  void _runBooksFilter(String enteredKeyword) {
    List<PoplarBooksModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = popularBooksData!;
    } else {
      results = popularBooksData!
          .where((user) =>
              user.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _popularFoundBooks = results;
    });
  }

  void _runAuthorFilter(String enteredKeyword) {
    List<PoplarBooksModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = popularBooksData!;
    } else {
      results = popularBooksData!
          .where((user) => user.author!.name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _popularFoundBooks = results;
    });
  }

  /// bookmark method starts for browse widget
  int currentIndex = -1;
  late APIResponse<BookViewModel> _responseAddBookMark;
  bool isAdding = false;

  browseBookBookmark(BuildContext context, String bookID, int index) async {
    setState(() {
      isAdding = true;
      currentIndex = index;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": bookID,
    };
    _responseAddBookMark = await service.addBookMark(addData);
    if (_responseAddBookMark.status!.toLowerCase() == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book added to bookmarks successfully",
          ),
        ),
      );
      initPopularBooks(
        false,
        -1,
      );
    } else {
      showToastError(
        _responseAddBookMark.message,
        FToast().init(context),
      );
    }
    setState(() {
      isAdding = false;
    });
  }

  /// bookmark method ends

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
            105.w,
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
                    padding: EdgeInsets.only(
                      top: 55.0.h,
                      bottom: 40.h,
                      left: 144.w,
                      right: 20.w,
                    ),
                    child: Container(
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 159.w,
                              height: 42.w,
                              child: Text(
                                'Browse',
                                style: GoogleFonts.poppins(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
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
                  width: 343.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        color: Colors.white,
                        child: SizedBox(
                          width: 294.w,
                          height: 44.h,
                          child: TextField(
                            // expands: true, maxLines: null,
                            //onTap: () => searchBooksMethod(context),
                            onChanged: (value) =>
                                (isSelectedButton == 1 || isSelectedButton == 0)
                                    ? _runFilter(value)
                                    : isSelectedButton == 2
                                        ? _runBooksFilter(value)
                                        : _runAuthorFilter(value),
                            controller: searchController,
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                            cursorColor: const Color(
                              0xffE8B55B,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                top: 13.h,
                                bottom: 13.h,
                              ),
                              hintText: 'Search here',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: const Color(
                                  0xff6C6C6C,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.r,
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
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(
                          8.r,
                        ),
                        child: GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12.r,
                                  ),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                  width: 266.w,
                                  height: 148.w,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0.w,
                                      vertical: 12.h,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 92.w,
                                          height: 27.w,
                                          child: Text(
                                            'Search By',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Container(
                                              width: 57.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isSelectedButton == 1
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18.r,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isSelectedButton = 1;
                                                  });
                                                },
                                                child: Text(
                                                  'All',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: isSelectedButton == 1
                                                        ? const Color(
                                                            0xff00B900,
                                                          )
                                                        : const Color(
                                                            0xff000000,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.h,
                                            ),
                                            Container(
                                              width: 57.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isSelectedButton == 2
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18.r,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isSelectedButton = 2;
                                                  });
                                                },
                                                child: Text(
                                                  'Books',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          isSelectedButton == 2
                                                              ? const Color(
                                                                  0xff00B900)
                                                              : const Color(
                                                                  0xff000000,
                                                                )),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12.w,
                                            ),
                                            Container(
                                              width: 64.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xffF7F7F7,
                                                ),
                                                border: Border.all(
                                                  color: isSelectedButton == 3
                                                      ? const Color(
                                                          0xff00B900,
                                                        )
                                                      : Colors.transparent,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  18.r,
                                                ),
                                              ),
                                              child: TextButton(
                                                style: const ButtonStyle(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                onPressed: () {
                                                  isSelectedButton = 3;
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  'Author',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: isSelectedButton == 3
                                                        ? const Color(
                                                            0xff00B900,
                                                          )
                                                        : const Color(
                                                            0xff000000,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 61.w,
                                          height: 28.h,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffF7E683),
                                                Color(0xffF7E683),
                                                Color(0xffE8B55B)
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                          ),
                                          child: TextButton(
                                            style: const ButtonStyle(
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            onPressed: () {
                                              //isSelectedButton;

                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
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
                              );
                            }),
                          ),
                          child: Container(
                            width: 44.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                8.r,
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
                    padding: EdgeInsets.only(
                      top: 38.h,
                    ),
                    child: _popularFoundBooks.isNotEmpty
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            shrinkWrap: true,
                            itemCount: _popularFoundBooks.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 19.0.w,
                                    mainAxisSpacing: 24.0.h),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
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
                                  function: () => browseBookBookmark(
                                      context,
                                      _popularFoundBooks[index]
                                          .books_id!
                                          .toString(),
                                      index),
                                  isAdding: isAdding,
                                  index: index,
                                  currentIndex: currentIndex,
                                  isRemoving: isRemoving,
                                  indexToRemove: index,
                                  currentIndexToRemove: currentIndexToRemove,
                                  functionToRemove: () => bookMark(
                                      context,
                                      _popularFoundBooks[index]
                                          .books_id
                                          .toString(),
                                      index),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No resluts found',
                              style: TextStyle(fontSize: 32.sp),
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

  int currentIndexToRemove = -1;
  late APIResponse _responseRemoveBookMark;
  bool isRemoving = false;

  bookMark(BuildContext context, String id, int indexToRemove) async {
    setState(() {
      isRemoving = true;
      currentIndexToRemove = indexToRemove;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseRemoveBookMark = await service.removeBookMark(addData);
    if (_responseRemoveBookMark.status!.toLowerCase() == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book removed from bookmarks successfully",
          ),
        ),
      );
      initPopularBooks(false, -1);
      // setState(() {
      //   _popularFoundBooks!
      //       .removeWhere((element) => element.books_id!.toString() == id);
      // });
    } else {
      showToastError(
        _responseRemoveBookMark.message,
        FToast().init(context),
      );
    }
    setState(() {
      isRemoving = false;
    });
  }
}
