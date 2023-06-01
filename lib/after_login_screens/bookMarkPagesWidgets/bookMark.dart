import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/all_bookmarked_books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../Services/API_Services.dart';
import '../../before_login_screens/login_screens.dart';
import '../readBooks/read_book.dart';
import 'bookMarkFirstPageWidget.dart';

class BookMark extends StatefulWidget {
  const BookMark({Key? key}) : super(key: key);

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  late TextEditingController searchController;
  bool isAllSelected = false;
  bool isBooksSelected = false;
  bool isAuthorSelected = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  ApiServices get service => GetIt.I<ApiServices>();
  bool isLoading = false;
  late APIResponse<List<AllBooksBookMarked>> _response;
  List<AllBooksBookMarked> getAllBooks = [];
  late SecureSharedPref secureSharedPref;
  int userID = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    init();
  }

  bool isReading = false;
  init() async {
    setState(() {
      isLoading = true;
      isReading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;

    print(
      'id collected successfully on bookmark page ' + userID.toString(),
    );
    Map data = {
      "users_customers_id": userID.toString(),
    };
    _response = await service.allBookMarkedBooks(data);
    getAllBooks = [];
    print('object ' +
        _response.message.toString() +
        " " +
        _response.status.toString());
    if (_response.data != null) {
      // getAllBooks = _response.data!;
      for (AllBooksBookMarked model in _response.data!) {
        if (model.bookmarked!.toLowerCase() == 'yes') {
          getAllBooks.add(model);
          _popularFoundBooks = getAllBooks;
        }
      }
    }
    setState(() {
      isLoading = false;
      isReading = false;
    });
  }

  List<AllBooksBookMarked>? _popularFoundBooks = [];
  void _runFilter(String enteredKeyword) {
    List<AllBooksBookMarked> results = [];

    if (enteredKeyword.isEmpty) {
      print("sdsdsdsdsd " + enteredKeyword.toString());
      // if the search field is empty or only contains white-space, we'll display all users
      results = getAllBooks;
    } else {
      print("sdsdsdsdsd " + enteredKeyword.toString());
      results = getAllBooks
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                  left: 117,
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
                          'Bookmarks',
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
                        child: SvgPicture.asset('assets/buttons/logout.svg'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              child: SizedBox(
                width: 343,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            contentPadding: EdgeInsets.only(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
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
                  child: _popularFoundBooks!.isEmpty
                      ? Center(
                          child: Text(
                            'No books are bookmarked yet',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xff5B4214,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shrinkWrap: true,
                          itemCount: _popularFoundBooks!.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.6,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 19.0,
                                  mainAxisSpacing: 24.0),
                          itemBuilder: (BuildContext context, int index) {
                            return isReading
                                ? CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder: (context) => ReadBook(
                                          popularBooksGetModel:
                                              _popularFoundBooks![index]
                                                  .pages
                                                  .toString(),
                                          path: _popularFoundBooks![index]
                                              .book_url!,
                                        ),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: 330,
                                      child: BookMarkFirstPageWidget(
                                        allBooksBookMarked:
                                            _popularFoundBooks![index],
                                      ),
                                    ),
                                  );
                          },
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
