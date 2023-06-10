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

  /// bookmark method starts
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
      initPopularBooks(false, -1);
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
                                  function: () => browseBookBookmark(
                                      context,
                                      _popularFoundBooks[index]
                                          .books_id!
                                          .toString(),
                                      index),
                                  isAdding: isAdding,
                                  index: index,
                                  currentIndex: currentIndex,
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
}
