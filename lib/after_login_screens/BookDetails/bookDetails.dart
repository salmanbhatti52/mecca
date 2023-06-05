import 'dart:io';

import 'package:MeccaIslamicCenter/APIModels/book_download_model.dart';
import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  const BookDetails({Key? key, required this.popularBooksGetModel})
      : super(key: key);

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
    initRelatedBooks();
  }

  bool isRelatedBooksLoading = false;
  late APIResponse<List<RelatedBooksModel>> _responseRelatedBooks;
  List<RelatedBooksModel>? relatedBooksList;
  initRelatedBooks() async {
    setState(() {
      isRelatedBooksLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;

    print(
      'id collected successfully on details page ' + userID.toString(),
    );
    Map relatedData = {
      "users_customers_id": userID.toString(),
      "books_id": "16",
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
    setState(() {
      isRelatedBooksLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70,
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
              padding: const EdgeInsets.only(
                top: 53.0,
                bottom: 10,
                left: 24,
                right: 85,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      'assets/buttons/back-button.svg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(
                    width: 69,
                  ),
                  Text(
                    'Book Details',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      // color: Colors.blueGrey,
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 134,
                            height: 213,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
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
                          const SizedBox(
                            width: 11,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 190,
                                height: 48,
                                child: AutoSizeText(
                                  widget.popularBooksGetModel.title ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(
                                      0xff5B4214,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    widget.popularBooksGetModel.author!.name!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(
                                        0xff6C6C6C,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pages',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 13,
                                  ),
                                  AutoSizeText(
                                    '${widget.popularBooksGetModel.pages!}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(
                                        0xff6C6C6C,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 17,
                              ),
                              isBookMarkDone
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(
                                          0xffE8B55B,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => bookMark(
                                          context,
                                          widget.popularBooksGetModel.books_id
                                              .toString()),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                        width: 106,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          color: const Color(0xffF7F7F7),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            widget.popularBooksGetModel
                                                        .bookmarked!
                                                        .toLowerCase() ==
                                                    'yes'
                                                ? SvgPicture.asset(
                                                    'assets/buttons/save.svg',
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Color(
                                                              0xff00B900,
                                                            ),
                                                            BlendMode.srcIn),
                                                    // fit: BoxFit.scaleDown,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/buttons/save.svg',
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Color(
                                                              0xff6C6C6C,
                                                            ),
                                                            BlendMode.srcIn),
                                                    // fit: BoxFit.scaleDown,
                                                  ),
                                            Text(
                                              'Bookmark',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xff6C6C6C)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: isBookMarkDone ? 14 : 10,
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
                                          width: 200.0,
                                          lineHeight: 18.0,
                                          percent: percent,
                                          center: Text(
                                            "Downloading...(${percent * 100} %)",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: const Color(
                                                0xff5B4214,
                                              ),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          barRadius: const Radius.circular(10),
                                          backgroundColor: Colors.grey,
                                          progressColor:
                                              const Color(0xffE8B55B),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            _listenForPermissionStatus(
                                                context,
                                                widget.popularBooksGetModel
                                                    .books_id
                                                    .toString());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            width: 106,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                              color: const Color(0xffF7F7F7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/download.svg',
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
                                                      fontSize: 13,
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
                    const SizedBox(
                      height: 25,
                    ),
                    isReading
                        ? Container(
                            width: 337,
                            height: 63,
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
                                12,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'PLEASE WAIT',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
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
                            width: 337,
                            height: 63,
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
                                12,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 237,
                                height: 37,
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
                                      fontSize: 18,
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Related Books',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color(
                                0xff000000,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    isRelatedBooksLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE8B55B),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            shrinkWrap: true,
                            itemCount: relatedBooksList!.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.6,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 19.0,
                                    mainAxisSpacing: 24.0),
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 310,
                                child: BookDetailsWidget(
                                    relatedBooksModel:
                                        relatedBooksList![index]),
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

  late APIResponse<BookViewModel> _responseAddBookMark;

  bool isBookMarkDone = false;
  bookMark(BuildContext context, String id) async {
    setState(() {
      isBookMarkDone = true;
    });
    Map addData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseAddBookMark = await service.addBookMark(addData);
    print(_responseAddBookMark.data.toString());
    if (_responseAddBookMark.status!.toLowerCase() == 'success') {
      showToastSuccess(
          'Book added to bookmarks successfully', FToast().init(context));
    } else {
      showToastError(
        _responseAddBookMark.message,
        FToast().init(context),
      );
    }
    setState(() {
      isBookMarkDone = false;
    });
  }

  bool isDownloading = false;
  late APIResponse<BookDownloadModel> _responseDownload;

  void _listenForPermissionStatus(BuildContext context, String id) async {
    final permissionStatus = await Permission.storage.status;
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
    //get pdf from link
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

    setState(() {
      isDownloading = false;
      isDownloadStarts = false;
    });
    showToastSuccess('Book Downloaded Successfully', FToast().init(context));
    //write in download folder
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
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
    var path = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    Map downloadData = {
      "users_customers_id": userID.toString(),
      "books_id": id,
    };
    _responseDownload = await service.bookDownload(downloadData);

    if (_responseDownload.status!.toLowerCase() == 'success') {
      showToastSuccess(
        'Download has been started',
        FToast().init(context),
      );
      String fullPathName =
          "$path/${_responseDownload.data!.title!.trim()}.pdf";

      download2(
          dio,
          'https://mecca.eigix.net/public/${_responseDownload.data!.book_url}',
          fullPathName);
    } else {
      showToastError(_responseDownload.message, FToast().init(context));
    }
    setState(() {
      isDownloading = false;
    });
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
}
