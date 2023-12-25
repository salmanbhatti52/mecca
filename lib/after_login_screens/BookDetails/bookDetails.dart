import 'dart:io';

import 'package:MeccaIslamicCenter/APIModels/book_download_model.dart';
import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:MeccaIslamicCenter/bottomNavigatorBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../APIModels/API_Response.dart';
import '../../APIModels/RelatedBooksModel.dart';
import '../../APIModels/book_view.dart';
import '../../Services/API_Services.dart';
import '../../Utilities/showToast.dart';
import '../readBooks/read_book.dart';
import 'bookDetailsWidget.dart';

class BookDetails extends StatefulWidget {
  final PoplarBooksModel popularBooksGetModel;

  const BookDetails({
    Key? key,
    required this.popularBooksGetModel,
  }) : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  ApiServices get service => GetIt.I<ApiServices>();
  bool isLoading = false;
  late SecureSharedPref secureSharedPref;
  int userID = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRelatedBooks(widget.popularBooksGetModel.books_id!.toString());
  }

  bool isRelatedBooksLoading = false;
  late APIResponse<List<RelatedBooksModel>> _responseRelatedBooks;
  List<RelatedBooksModel>? relatedBooksList;
  List<PoplarBooksModel>? popularBooksData;

  late APIResponse<List<PoplarBooksModel>> _responsePopularBooks;

  initRelatedBooks(String id) async {
    setState(() {
      isRelatedBooksLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;
    Map relatedData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    Map dataPopular = {
      "users_customers_id": userID.toString(),
    };
    _responseRelatedBooks = await service.relatedBooks(relatedData);
    relatedBooksList = [];
    if (_responseRelatedBooks.status!.toLowerCase() == 'success') {
      relatedBooksList = _responseRelatedBooks.data;
    } else {
      showToastError(
        _responseRelatedBooks.message,
        FToast().init(context),
      );
    }
    _responsePopularBooks = await service.getPopularBooks(dataPopular);
    popularBooksData = [];
    if (_responsePopularBooks.status!.toLowerCase() == 'success') {
      // await prefs.putInt('bookID', _responsePopularBooks.data!.);
      for (PoplarBooksModel model in _responsePopularBooks.data!) {
        popularBooksData!.add(model);
      }
    }
    if (popularBooksData!
            .firstWhere((element) =>
                element.books_id == widget.popularBooksGetModel.books_id)
            .bookmarked!
            .toLowerCase() ==
        'yes') {
      setState(() {
        isBookmarked = true;
      });
    } else {
      setState(() {
        isBookmarked = false;
      });
    }
    setState(() {
      isRelatedBooksLoading = false;
    });
  }

  bool isBookmarked = false;

  // bookmark method starts here
  int currentIndex = -1;
  late APIResponse<BookViewModel> _responseAddRelatedBooks;
  bool isAdding = false;

  featuredBookBookmark(BuildContext context, String id, int index) async {
    setState(() {
      isAdding = true;
      currentIndex = index;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseAddRelatedBooks = await service.addBookMark(addData);
    if (_responseAddRelatedBooks.status!.toLowerCase() == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Book added to bookmarks successfully",
          ),
        ),
      );
      initRelatedBooks(widget.popularBooksGetModel.books_id!.toString());
    } else {
      showToastError(
        _responseAddRelatedBooks.message,
        FToast().init(context),
      );
    }
    setState(() {
      isAdding = false;
    });
  }

  // bookmark method end here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70.w,
          ),
          child: Container(
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
            child: Padding(
              padding: EdgeInsets.only(
                top: 53.0.h,
                bottom: 10.h,
                left: 24.w,
                right: 85.w,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationBarScreens(),
                          ),
                        );
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/buttons/back-button.svg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(
                    width: 69.w,
                  ),
                  Text(
                    'Book Details',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 28.sp,
                      color: const Color(
                        0xff5B4214,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: const Color(0xffE8B55B),
              child: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      // color: Colors.blueGrey,
                      width: MediaQuery.of(context).size.width.w,
                      height: 230.w,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 134.w,
                            height: 213.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12.r,
                              ),
                              child: Image.network(
                                'https://mecca.eigix.net/public/${widget.popularBooksGetModel.cover}',
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container(
                                    child: Image.asset(
                                        'assets/images/placeholder_image.png'),
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 11.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 190.w,
                                height: 48.w,
                                child: AutoSizeText(
                                  widget.popularBooksGetModel.title ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(
                                      0xff5B4214,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.h,
                                  ),
                                  AutoSizeText(
                                    widget.popularBooksGetModel.author!.name!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(
                                        0xff6C6C6C,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pages',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  AutoSizeText(
                                    '${widget.popularBooksGetModel.pages!}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(
                                        0xff6C6C6C,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 17.h,
                              ),
                              isBookMarkDone
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(
                                          0xffE8B55B,
                                        ),
                                      ),
                                    )
                                  : isRelatedBooksLoading
                                      ? CircularProgressIndicator(
                                          color: Color(0xffE8B55B),
                                          strokeWidth: 0.9,
                                        )
                                      : GestureDetector(
                                          onTap: () => !isBookmarked
                                              ? bookMark(
                                                  context,
                                                  widget.popularBooksGetModel
                                                      .books_id
                                                      .toString())
                                              : bookMarkRemove(
                                                  context,
                                                  widget.popularBooksGetModel
                                                      .books_id
                                                      .toString()),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 6.h,
                                            ),
                                            width: 106.w,
                                            height: 30.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15.r,
                                              ),
                                              color: const Color(0xffF7F7F7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                isBookmarked
                                                    ? isAdding
                                                        ? SizedBox(
                                                            width: 20.w,
                                                            height: 25.h,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Color(
                                                                  0xffE8B55B),
                                                              strokeWidth: 0.9,
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            'assets/buttons/save.svg',
                                                            width: 16.w,
                                                            height: 16.h,
                                                            fit: BoxFit.cover,
                                                            colorFilter:
                                                                const ColorFilter
                                                                        .mode(
                                                                    Color(
                                                                      0xff00B900,
                                                                    ),
                                                                    BlendMode
                                                                        .srcIn),
                                                            // fit: BoxFit.scaleDown,
                                                          )
                                                    : SvgPicture.asset(
                                                        'assets/buttons/save.svg',
                                                        width: 16.w,
                                                        height: 16.h,
                                                        fit: BoxFit.cover,
                                                        colorFilter:
                                                            const ColorFilter
                                                                    .mode(
                                                                Color(
                                                                  0xff6C6C6C,
                                                                ),
                                                                BlendMode
                                                                    .srcIn),
                                                        // fit: BoxFit.scaleDown,
                                                      ),
                                                Text(
                                                  'Bookmark',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xff6C6C6C)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                              SizedBox(
                                height: isBookMarkDone ? 14.h : 10.h,
                              ),
                              isDownloading
                                  ? const SizedBox(
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xffE8B55B),
                                        ),
                                      ),
                                    )
                                  : isDownloadStarts
                                      ? LinearPercentIndicator(
                                          width: 200.0.w,
                                          lineHeight: 18.0.w,
                                          percent: percent,
                                          center: Text(
                                            "Downloading...(${percent * 100} %)",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12.sp,
                                              color: const Color(
                                                0xff5B4214,
                                              ),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          barRadius: Radius.circular(10.r),
                                          backgroundColor: Colors.grey,
                                          progressColor:
                                              const Color(0xffE8B55B),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            downloadBook(
                                                context,
                                                widget.popularBooksGetModel
                                                    .books_id
                                                    .toString());
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 6.h,
                                            ),
                                            width: 106.w,
                                            height: 30.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15.r,
                                              ),
                                              color: const Color(0xffF7F7F7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/download.svg',
                                                  width: 16.w,
                                                  height: 16.h,
                                                  fit: BoxFit.cover,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Color(
                                                            0xff6C6C6C,
                                                          ),
                                                          BlendMode.srcIn),
                                                  // fit: BoxFit.scaleDown,
                                                ),
                                                Text(
                                                  'Download',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xff6C6C6C)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    isReading
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 26.w),
                            width: double.infinity,
                            height: 63.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(
                                    0xffF7E683,
                                  ),
                                  Color(
                                    0xffE8B55B,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                12.r,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'PLEASE WAIT',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  const CircularProgressIndicator(
                                    color: Color(
                                      0xff5B4214,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 26.w),
                            width: double.infinity,
                            height: 63.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(
                                    0xffF7E683,
                                  ),
                                  Color(
                                    0xffE8B55B,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                12.r,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 37.h,
                                child: MaterialButton(
                                  focusColor: const Color(0xffF7E683),
                                  splashColor: const Color(0xffF7E683),
                                  onPressed: () => readBooks(
                                      context,
                                      widget.popularBooksGetModel.books_id
                                          .toString()),
                                  child: Text(
                                    'READ NOW',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Related Books',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(
                                0xff000000,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    isRelatedBooksLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE8B55B),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                            ),
                            shrinkWrap: true,
                            itemCount: relatedBooksList!.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 19.0.w,
                                    mainAxisSpacing: 24.0.h),
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 310.h,
                                child: BookDetailsWidget(
                                  relatedBooksModel: relatedBooksList![index],
                                  function: () => featuredBookBookmark(
                                      context,
                                      relatedBooksList![index]
                                          .books_id!
                                          .toString(),
                                      index),
                                  isAdding: isAdding,
                                  index: index,
                                  currentIndex: currentIndex,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isDownloading = false;
  late APIResponse<BookDownloadModel> _responseDownload;

  // void _listenForPermissionStatus(BuildContext context, String id) async {
  //   final permissionStatus = await Permission.manageExternalStorage.request();
  //
  //   if (permissionStatus.isDenied) {
  //     // Here ask for the permission for the first time
  //     final newPermissionStatus = await Permission.storage.request();
  //
  //     if (newPermissionStatus.isDenied) {
  //       // Permission is still denied, handle it within the app
  //       // You can show a dialog or UI to inform the user
  //       // that permission is required for certain functionality.
  //       // Optionally, you can provide a button to request the permission again.
  //
  //       // Example: Show a dialog
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Permission Required'),
  //           content: Text('Please grant the storage permission to use this feature.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // Close the dialog
  //                 _listenForPermissionStatus(context, id); // Request permission again
  //               },
  //               child: Text('Retry'),
  //             ),
  //           ],
  //         ),
  //       );
  //
  //       // Alternatively, you can directly call the function to request permission again.
  //       // _listenForPermissionStatus(context, id);
  //     } else {
  //       // Permission is granted, proceed with your logic
  //       downloadBook(context, id);
  //     }
  //   } else if (permissionStatus.isPermanentlyDenied) {
  //     // Handle permanently denied state within the app
  //     // You can show a dialog or UI to inform the user
  //     // that they need to enable the permission manually in app settings.
  //
  //     // Example: Show a dialog
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Permission Required'),
  //         content: Text('Please enable the storage permission in app settings to use this feature.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //               openAppSettings(); // Open app settings
  //             },
  //             child: Text('Open Settings'),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     // Permission is granted, proceed with your logic
  //     downloadBook(context, id);
  //   }
  // }

  void _listenForPermissionStatus(BuildContext context, String id) async {
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isDenied) {
      // Here just ask for the permission for the first time
      await Permission.storage.request();

      // I noticed that sometimes popup won't show after user press deny
      // so I do the check once again but now go straight to appSettings
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Here open app settings for user to manually enable permission in case
      // where permission was permanently denied
      await openAppSettings();
    } else {
      // Do stuff that require permission here

      downloadBook(context, id);
    }
  }

  Future download2(Dio dio, String url, String savePath) async {
    setState(() {
      isDownloadStarts = true;
    });

    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      showToastSuccess('Book Downloaded Successfully', FToast().init(context));
      setState(() {
        isDownloading = false;
        isDownloadStarts = false;
      });
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print('Error: $e');
      setState(() {
        isDownloading = false;
        isDownloadStarts = false;
      });
      showToastError('Failed to download the file', FToast().init(context));
    }
  }

//progress bar
  bool isDownloadStarts = false;
  String progressPercentage = '';
  double percent = 0.0;

  showDownloadProgress(received, total) {
    percent = 0.0;
    if (total != -1) {
      setState(() {
        percent = (((received / total * 100).toInt()).toDouble() / 100);
      });
      progressPercentage = (received / total * 100).toStringAsFixed(0) + "%";
    }
  }

  var dio = Dio();

  downloadBook(BuildContext context, String id) async {
    setState(() {
      isDownloading = true;
    });
    // var path = await ExternalPath.getExternalStoragePublicDirectory(
    //     ExternalPath.DIRECTORY_DOWNLOADS);
    // Directory path = Platform.isAndroid
    //     ? await getApplicationDocumentsDirectory()
    //     : await getApplicationSupportDirectory();

    // var tempDir = await getTemporaryDirectory();

    // if(Platform.isAndroid) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);

      Map downloadData = {
        "users_customers_id": userID.toString(),
        "books_id": id,
      };
      _responseDownload = await service.bookDownload(downloadData);

      if (_responseDownload.status!.toLowerCase() == 'success') {
        // showToastSuccess(
        //   'Download has been started',
        //   FToast().init(context),
        // );

        // String fileName = "${_responseDownload.data!.title!.trim()}.pdf";
        // String fullPathName = path.join(tempDir.path, fileName);

        String fullPath = "${dir.path}/${_responseDownload.data!.title!.trim()}.pdf";
        print('full path $fullPath');
        print('https://mecca.eigix.net/public/${_responseDownload.data!.book_url}');

        await shareBook(fullPath);

        // download2(
        //     dio,
        //     'https://mecca.eigix.net/public/${_responseDownload.data!.book_url}',
        //     fullPath);

      } else {
        showToastError(_responseDownload.message, FToast().init(context));
      }
    // }  else {
    //
    //   Directory dir = await getApplicationDocumentsDirectory();
    //
    //   Map downloadData = {
    //     "users_customers_id": userID.toString(),
    //     "books_id": id,
    //   };
    //   _responseDownload = await service.bookDownload(downloadData);
    //
    //   if (_responseDownload.status!.toLowerCase() == 'success') {
    //     showToastSuccess(
    //       'Download has been started',
    //       FToast().init(context),
    //     );
    //
    //     // String fileName = "${_responseDownload.data!.title!.trim()}.pdf";
    //     // String fullPathName = path.join(tempDir.path, fileName);
    //
    //     String fullPath = "${dir.path}/${_responseDownload.data!.title!.trim()}.pdf";
    //     print('full path $fullPath');
    //     print('https://mecca.eigix.net/public/${_responseDownload.data!.book_url}');
    //
    //     download2(
    //         dio,
    //         'https://mecca.eigix.net/public/${_responseDownload.data!.book_url}',
    //         fullPath);
    // }
    // }
    setState(() {
      isDownloading = false;
    });
  }

  Future<void> shareBook(String filePath) async {
    try {
      await Share.shareFiles([filePath], text: 'Check out this book!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  bool isReading = false;
  late APIResponse<BookViewModel> _responseReadBook;

  readBooks(BuildContext context, String bookID) async {
    setState(() {
      isReading = true;
    });
    Map readData = {
      "users_customers_id": userID.toString(),
      "books_id": bookID,
    };
    print('data to read has been get ' + readData.toString());
    _responseReadBook = await service.bookView(readData);
    print('data to read has been get and response generated ' +
        readData.toString());
    if (_responseReadBook.status!.toLowerCase() == 'success') {
      print('successful response ' + readData.toString());
      showToastSuccess(
        _responseReadBook.status,
        FToast().init(context),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReadBook(
            popularBooksGetModel: widget.popularBooksGetModel.pages.toString(),
            path: '${widget.popularBooksGetModel.book_url}',
          ),
        ),
      );
    } else {
      print('unsuccessful response ' +
          readData.toString() +
          _responseReadBook.message.toString());
      showToastError(
        _responseReadBook.message,
        FToast().init(context),
      );
    }
    setState(() {
      isReading = false;
    });
  }

  late APIResponse<BookViewModel> _responseAddBookMarkForBookDetails;

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
    _responseAddBookMarkForBookDetails = await service.addBookMark(addData);
    print(_responseAddBookMarkForBookDetails.data.toString());
    if (_responseAddBookMarkForBookDetails.status!.toLowerCase() == 'success') {
      showToastSuccess(
          'Book added to bookmarks successfully', FToast().init(context));
      initRelatedBooks(id);
    } else {
      showToastError(
        _responseAddBookMarkForBookDetails.message,
        FToast().init(context),
      );
    }
    setState(() {
      isBookMarkDone = false;
    });
  }

  // int currentIndexToRemove = -1;
  late APIResponse _responseRemoveBookMark;
  bool isRemoving = false;
  bookMarkRemove(BuildContext context, String id) async {
    setState(() {
      isBookMarkDone = true;
      // currentIndexToRemove = indexToRemove;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseRemoveBookMark = await service.removeBookMark(addData);
    if (_responseRemoveBookMark.status!.toLowerCase() == 'success') {
      showToastSuccess(
          "Book removed from bookmarks successfully", FToast().init(context));
      initRelatedBooks(id);
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
      isBookMarkDone = false;
    });
  }
}
