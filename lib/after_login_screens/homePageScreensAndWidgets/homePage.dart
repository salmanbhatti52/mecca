import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:MeccaIslamicCenter/after_login_screens/BookDetails/bookDetails.dart';
import 'package:MeccaIslamicCenter/after_login_screens/homePageScreensAndWidgets/topBooksWidget.dart';
import 'package:MeccaIslamicCenter/before_login_screens/login_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../APIModels/API_Response.dart';
import '../../APIModels/book_view.dart';
import '../../APIModels/category_model_get.dart';
import '../../Services/API_Services.dart';
import '../../Utilities/showToast.dart';
import 'categoriesWidget.dart';
import 'featuredBooksWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;
  // List<int> isSelected = [1, 2, 3];
  int isSelectedButton = 0;
  // bool isAllSelected = false;
  // bool isBooksSelected = false;
  // bool isAuthorSelected = false;

  bool isHomeLoading = false;
  late SecureSharedPref secureSharedPref;
  int userID = -1;
  ApiServices get service => GetIt.I<ApiServices>();
  bool isNameLoading = false;
  bool isPopuplarBooksLoading = false;
  bool isTopBooksLoading = false;
  late APIResponse<List<CategoryGetModel>> _response;
  List<CategoryGetModel>? catNameList;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    init();
    initPopularBooks(
      false,
      -1,
    );
    initTopBooksBasedOnDownloads();
  }

  bool isBookIdLoading = false;
  // late SecureSharedPref prefs;
  init() async {
    setState(() {
      isNameLoading = true;
      isHomeLoading = true;
      isBookIdLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;

    _response = await service.getCategory();
    catNameList = [];
    if (_response.status!.toLowerCase() == 'success') {
      catNameList = _response.data!;
    } else {
      showToastError(
        _response.message,
        FToast().init(context),
      );
    }
    setState(() {
      isNameLoading = false;
      isHomeLoading = false;
    });
  }

  /// Bookmark Method for home books
  int currentIndex = -1;
  late APIResponse<BookViewModel> _responseAddBookMark;
  bool isAdding = false;
  bool isBookMarked = false;

  featuredBookBookmark(BuildContext context, String id, int index) async {
    setState(() {
      isAdding = true;
      isBookMarked = true;
      currentIndex = index;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
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
      initTopBooksBasedOnDownloads();
    } else {
      showToastError(
        _responseAddBookMark.message,
        FToast().init(context),
      );
    }
    setState(() {
      isAdding = false;
      isBookMarked = false;
    });
  }

  /// bookmark method ended here

  /// bookmark method for top books starts
  int currentIndexTop = -1;
  late APIResponse<BookViewModel> _responseAddBookMarkInTopBooks;
  bool isAddingInTopBooks = false;
  topBooksBookmark(BuildContext context, String id, index) async {
    setState(() {
      isAddingInTopBooks = true;
      currentIndexTop = index;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseAddBookMarkInTopBooks = await service.addBookMark(addData);
    if (_responseAddBookMarkInTopBooks.status!.toLowerCase() == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book added to bookmarks successfully",
          ),
        ),
      );
      initTopBooksBasedOnDownloads();
      initPopularBooks(
        false,
        -1,
      );
    } else {
      showToastError(
        _responseAddBookMarkInTopBooks.message,
        FToast().init(context),
      );
    }
    setState(() {
      isAddingInTopBooks = false;
    });
  }

  /// bookmark method for top books ends here
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
    print("my id: $userID");
    Map dataPopular = {
      "users_customers_id": userID.toString(),
    };
    _responsePopularBooks = await service.getPopularBooks(dataPopular);
    popularBooksData = [];
    _popularFoundBooks = [];
    if (_responsePopularBooks.status!.toLowerCase() == 'success') {
      // await prefs.putInt('bookID', _responsePopularBooks.data!.);
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

  late APIResponse<List<PoplarBooksModel>> _responseTopBooks;
  List<PoplarBooksModel>? topBooksData;

  initTopBooksBasedOnDownloads() async {
    setState(() {
      isTopBooksLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;
    Map dataPopular = {
      "users_customers_id": userID.toString(),
    };
    _responseTopBooks = await service.getPopularBooks(dataPopular);
    topBooksData = [];
    if (_responseTopBooks.status!.toLowerCase() == 'success') {
      topBooksData = _responseTopBooks.data;
      print("Data length ${topBooksData?.length}");
    } else {
      showToastError(
        _responseTopBooks.message,
        FToast().init(context),
      );
    }
    setState(() {
      isTopBooksLoading = false;
    });
  }

  // bool isSearching = false;
  // late APIResponse<List<AllBooksBookMarked>> _responseSearchBooks;
  // List<AllBooksBookMarked>? searchList;
  // searchBooksMethod(BuildContext context) async {
  //   print('search method provoked!');
  //   setState(() {
  //     isSearching = true;
  //   });
  //   Map searchData = {
  //     "search_query": "Imam" // seach by category.name,author.name or book.title
  //   };
  //   _responseSearchBooks = await service.searchBooks(searchData);
  //   searchList = [];
  //   if (_responseSearchBooks.status!.toLowerCase() == 'success') {
  //     print('search is started successfully');
  //     searchList = _responseSearchBooks.data;
  //   } else {
  //     print('search is cancelled ');
  //     showToastError(_responseSearchBooks.message, FToast().init(context));
  //   }
  // }

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
            140.w,
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
                      left: 20.0.w,
                      top: 70.h,
                      right: 20.w,
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   height: 70,
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 145.w,
                              height: 27.w,
                              child: Text(
                                'Welcome to the',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 170,
                            // ),
                            GestureDetector(
                              onTap: () => logout(context),
                              child: SvgPicture.asset(
                                'assets/buttons/logout.svg',
                                width: 18.w,
                                height: 18.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 284.w,
                              height: 42.w,
                              child: Text(
                                'Islamic Book Library',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28.sp,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                              print(
                                                  isSelectedButton.toString());
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
        body: SafeArea(
          child: isHomeLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(
                      0xffE8B55B,
                    ),
                  ),
                )
              : ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: const Color(0xffE8B55B),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          top: 14.h,
                          bottom: 14.h,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  height: 27.w,
                                  child: Text(
                                    'Categories',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff000000,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            isNameLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xffE8B55B),
                                    ),
                                  )
                                : SizedBox(
                                    height: 30.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.0.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('category print123 ' +
                                                  catNameList![index]
                                                      .categories_id
                                                      .toString());

                                              setState(() {
                                                popularBooksData = [];
                                                if (catNameList![index]
                                                    .isCategorySelected!) {
                                                  setState(() {
                                                    catNameList![index]
                                                            .isCategorySelected =
                                                        false;
                                                    initPopularBooks(
                                                      false,
                                                      -1,
                                                    );
                                                  });
                                                } else {
                                                  for (CategoryGetModel model
                                                      in catNameList!) {
                                                    setState(() {
                                                      model.isCategorySelected =
                                                          false;
                                                    });
                                                  }
                                                  setState(() {
                                                    catNameList![index]
                                                            .isCategorySelected =
                                                        true;
                                                  });
                                                  initPopularBooks(
                                                    true,
                                                    catNameList![index]
                                                        .categories_id!,
                                                  );
                                                }
                                                print("abayyyy " +
                                                    catNameList![index]
                                                        .isCategorySelected
                                                        .toString());
                                              });

                                              // initPopularBooks(
                                              //     true,
                                              //     catNameList![index]
                                              //         .categories_id!);
                                            },
                                            child: CategoriesWidget(
                                              categoryGetModel:
                                                  catNameList![index],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: catNameList!.length,
                                    ),
                                  ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 141.w,
                                  height: 27.w,
                                  child: Text(
                                    'Featured Books',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff000000,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            isPopuplarBooksLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xffE8B55B),
                                    ),
                                  )
                                : SizedBox(
                                    height: 310.h,
                                    child: _popularFoundBooks.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(
                                                      context,
                                                      rootNavigator: true,
                                                    ).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookDetails(
                                                          popularBooksGetModel:
                                                              _popularFoundBooks[
                                                                  index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: FeaturedBooksWidget(
                                                    function: () =>
                                                        featuredBookBookmark(
                                                            context,
                                                            _popularFoundBooks[
                                                                    index]
                                                                .books_id
                                                                .toString(),
                                                            index),
                                                    popularBooksGetModel:
                                                        _popularFoundBooks[
                                                            index],
                                                    isAdding: isAdding,
                                                    index: index,
                                                    currentIndex: currentIndex,
                                                    isRemovingFromFeatured:
                                                        isRemovingFromFeatured,
                                                    indexToRemoveFromFeatured:
                                                        index,
                                                    currentIndexToRemoveFromFeatured:
                                                        currentIndexToRemoveFromFeatured,
                                                    functionToRemoveFromFeatured: () =>
                                                        bookMarkRemoveFromFeatured(
                                                            context,
                                                            _popularFoundBooks[
                                                                    index]
                                                                .books_id
                                                                .toString(),
                                                            index),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount:
                                                _popularFoundBooks.length,
                                          )
                                        : Text(
                                            'No results found',
                                            style: TextStyle(fontSize: 24.sp),
                                          ),
                                  ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 141.h,
                                  height: 27.w,
                                  child: Text(
                                    'Top Books',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff000000,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            isTopBooksLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xffE8B55B),
                                    ),
                                  )
                                : SizedBox(
                                    height: 310.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return topBooksData![index]
                                                    .downloads! >=
                                                1
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0.w),
                                                child: topBooksData![index] !=
                                                        null
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(
                                                            context,
                                                            rootNavigator: true,
                                                          ).push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      BookDetails(
                                                                popularBooksGetModel:
                                                                    topBooksData![
                                                                        index],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: TopBooksWidget(
                                                          popularBooksGetModelTop:
                                                              topBooksData![
                                                                  index],
                                                          function: () =>
                                                              topBooksBookmark(
                                                                  context,
                                                                  _popularFoundBooks[
                                                                          index]
                                                                      .books_id
                                                                      .toString(),
                                                                  index),
                                                          isAddingInTopBooks:
                                                              isAddingInTopBooks,
                                                          index: index,
                                                          currentIndex:
                                                              currentIndexTop,
                                                          isRemovingFromTop:
                                                              isRemovingFromTop,
                                                          indexToRemoveFromTopFromTop:
                                                              index,
                                                          functionToRemoveFromTop: () =>
                                                              bookMarkRemoveFromTop(
                                                                  context,
                                                                  _popularFoundBooks[
                                                                          index]
                                                                      .books_id
                                                                      .toString(),
                                                                  index),
                                                          currentIndexToRemoveFromTop:
                                                              currentIndexToRemoveFromTop,
                                                        ),
                                                      )
                                                    : const Center(
                                                        child: Text(
                                                            'No top books yet'),
                                                      ),
                                              )
                                            : const SizedBox();
                                      },
                                      itemCount: topBooksData!.length,
                                    ),
                                  ),
                          ],
                        ),
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

  late APIResponse<BookViewModel> _responseAddBookMarkBookDetails;

  bool isBookMarkDone = false;
  bookMark(
    BuildContext context,
    String id,
  ) async {
    setState(() {
      isBookMarkDone = true;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseAddBookMarkBookDetails = await service.addBookMark(addData);
    print(_responseAddBookMarkBookDetails.data.toString());
    if (_responseAddBookMarkBookDetails.status!.toLowerCase() == 'success') {
      showToastSuccess(
          'Book added to bookmarks successfully', FToast().init(context));
    } else {
      showToastError(
        _responseAddBookMarkBookDetails.message,
        FToast().init(context),
      );
    }
    setState(() {
      isBookMarkDone = false;
    });
  }

  int currentIndexToRemoveFromFeatured = -1;
  late APIResponse _responseRemoveBookMarkFromFeatured;
  bool isRemovingFromFeatured = false;
  bookMarkRemoveFromFeatured(
      BuildContext context, String id, int indexToRemoveFromFeatured) async {
    setState(() {
      isRemovingFromFeatured = true;
      currentIndexToRemoveFromFeatured = indexToRemoveFromFeatured;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseRemoveBookMarkFromFeatured = await service.removeBookMark(addData);
    if (_responseRemoveBookMarkFromFeatured.status!.toLowerCase() ==
        'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book removed from bookmarks successfully",
          ),
        ),
      );
      initPopularBooks(false, -1);
      initTopBooksBasedOnDownloads();
      // setState(() {
      //   _popularFoundBooks!
      //       .removeWhere((element) => element.books_id!.toString() == id);
      // });
    } else {
      showToastError(
        _responseRemoveBookMarkFromFeatured.message,
        FToast().init(context),
      );
    }
    setState(() {
      isRemovingFromFeatured = false;
    });
  }

  int currentIndexToRemoveFromTop = -1;
  late APIResponse _responseRemoveBookMarkFromTop;
  bool isRemovingFromTop = false;
  bookMarkRemoveFromTop(
      BuildContext context, String id, int indexToRemoveFromTop) async {
    setState(() {
      isRemovingFromTop = true;
      currentIndexToRemoveFromTop = indexToRemoveFromTop;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseRemoveBookMarkFromTop = await service.removeBookMark(addData);
    if (_responseRemoveBookMarkFromTop.status!.toLowerCase() == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book removed from bookmarks successfully",
          ),
        ),
      );
      initTopBooksBasedOnDownloads();
      initPopularBooks(false, -1);
      // setState(() {
      //   _popularFoundBooks!
      //       .removeWhere((element) => element.books_id!.toString() == id);
      // });
    } else {
      showToastError(
        _responseRemoveBookMarkFromTop.message,
        FToast().init(context),
      );
    }
    setState(() {
      isRemovingFromTop = false;
    });
  }
}
