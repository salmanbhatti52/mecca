import 'dart:io';

import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ReadBook extends StatefulWidget {
  final String popularBooksGetModel;
  final bool? isShare;
  final String path;
  final String? downloadBookTitle;

  ReadBook(
      {Key? key,
      required this.popularBooksGetModel,
      this.isShare,
      this.downloadBookTitle,
      required this.path})
      : super(key: key);

  @override
  State<ReadBook> createState() => _ReadBookState();
}

class _ReadBookState extends State<ReadBook> {
  late PDFViewController pdfViewController;

  bool isPDFLoading = false;
  File? Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isPDFLoading = true;
    });
    var url = 'https://mecca.eigix.net/public/${widget.path}';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isPDFLoading = false;
    });
  }

  //  _listenForPermissionStatus(String fullPath) async {
  //     final permissionStatus = await Permission.storage.request();
  //     if (permissionStatus.isDenied) {
  //       // Here just ask for the permission for the first time
  //       await Permission.storage.request();

  //       // I noticed that sometimes popup won't show after user press deny
  //       // so I do the check once again but now go straight to appSettings
  //       if (permissionStatus.isDenied) {
  //         await openAppSettings();
  //       }
  //     } else if (permissionStatus.isPermanentlyDenied) {
  //       // Here open app settings for user to manually enable permission in case
  //       // where permission was permanently denied
  //       await openAppSettings();
  //     } else {
  //       // Do stuff that require permission here

  //       shareBook(fullPath);
  //     }
  // }

  _listenForPermissionStatus(String fullPath) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.manageExternalStorage.request();
      print("status $status");
      if (status.isGranted) {
        debugPrint("fullPath $fullPath");
        shareBook(fullPath);
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // openAppSettings();
      }
    } else if (Platform.isIOS) {
      status = await Permission.storage.request();
      print("status $status");
      if (status.isGranted) {
        debugPrint("fullPath $fullPath");
        shareBook(fullPath);
      } else if (status.isDenied || status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<void> shareBook(String filePath) async {
    try {
      debugPrint("fullPath $filePath");
      await Share.shareFiles([filePath]);
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }

  Future<void> _downloadFile(String url, String savePath) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('object' + widget.path.toString());
    // loadPdfFromNetwork();

    loadNetwork();
  }

  // File? path1;
  // Future<File> loadPdfFromNetwork() async {
  //   final response = await http
  //       .get(Uri.parse('https://mecca.eigix.net/public/${widget.path}'));
  //   final bytes = response.bodyBytes;
  //   return _storeFile('https://mecca.eigix.net/public/${widget.path}', bytes);
  // }
  //
  // Future<File> _storeFile(String url, List<int> bytes) async {
  //   final filename = basename(url);
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/$filename');
  //   await file.writeAsBytes(bytes, flush: true);
  //   if (kDebugMode) {
  //     print('$file');
  //   }
  //   path1 = file;
  //   print('object pth1' + path1.toString());
  //   return file;
  // }
  int? pages = 1;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            111.w,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
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
                top: 63.0.h,
                bottom: 40.h,
                left: 24.w,
                right: 20.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      'assets/buttons/back-button.svg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  // SizedBox(
                  //   width: 97.w,
                  // ),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.r,
                            ),
                            side: const BorderSide(
                              color: Color(
                                0xffE8B55B,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: 300.w,
                            height: 300.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0.w,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80.h,
                                    width: 220.w,
                                    // color: Colors.red,
                                    child: AutoSizeText(
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      minFontSize: 20,
                                      'Enter the page number you want to go to',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(
                                          0xff5B4214,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  SizedBox(
                                    width: 70.w,
                                    height: 50.h,
                                    child: Center(
                                      child: TextField(
                                        textInputAction: TextInputAction.go,
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(
                                            7,
                                          ),
                                        ],
                                        maxLength:
                                            widget.popularBooksGetModel.length,
                                        // onChanged: (val) {
                                        //   setState(() {
                                        //     pdfViewController
                                        //         .setPage(int.parse(val));
                                        //     print('page jump ' +
                                        //         currentPage.toString());
                                        //   });
                                        //   //Navigator.of(context).pop();
                                        // },
                                        onSubmitted: (val) {
                                          if (int.parse(val) >
                                              int.parse(widget
                                                  .popularBooksGetModel)) {
                                            showToastError(
                                                'the page you are trying to access does not exist',
                                                FToast().init(context));
                                          } else {
                                            setState(() {
                                              pdfViewController
                                                  .setPage(int.parse(val));
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        keyboardType: TextInputType.text,
                                        cursorColor: const Color(
                                          0xffE8B55B,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(
                                            0xff5B4214,
                                          ),
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(
                                                0xffE8B55B,
                                              ),
                                            ),
                                          ),
                                          fillColor: Colors.white60,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(
                                                0xffE8B55B,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  // MaterialButton(
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       // pdfViewController
                                  //       //     .setPage(int.parse(val));
                                  //       // print('page jump ' +
                                  //       //     currentPage.toString());
                                  //       Navigator.of(context).pop();
                                  //     });
                                  //   },
                                  //   child: Container(
                                  //     width: 70.w,
                                  //     height: 40.h,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.red,
                                  //       borderRadius:
                                  //           BorderRadius.circular(5.r),
                                  //     ),
                                  //     child: Center(
                                  //       child: Text(
                                  //         'OK',
                                  //         style: GoogleFonts.urbanist(
                                  //           fontSize: 22,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: currentPage!.bitLength == 0
                              ? 24.w
                              : currentPage!.bitLength == 1
                                  ? 24.w
                                  : currentPage!.bitLength == 2
                                      ? 24.w
                                      : currentPage!.bitLength == 3
                                          ? 24.w
                                          : currentPage!.bitLength == 4
                                              ? 24.w
                                              : currentPage!.bitLength == 5
                                                  ? 25.w
                                                  : currentPage!.bitLength == 6
                                                      ? 26.w
                                                      : currentPage!
                                                                  .bitLength ==
                                                              7
                                                          ? 26.w
                                                          : currentPage!
                                                                      .bitLength ==
                                                                  8
                                                              ? 27.w
                                                              : currentPage!
                                                                          .bitLength ==
                                                                      9
                                                                  ? 28.w
                                                                  : currentPage!
                                                                              .bitLength ==
                                                                          10
                                                                      ? 29.w
                                                                      : currentPage!.bitLength ==
                                                                              11
                                                                          ? 30.w
                                                                          : currentPage!.bitLength == 12
                                                                              ? 31.w
                                                                              : null,
                          height: 21.w,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff5B4214,
                            ),
                            borderRadius: BorderRadius.circular(
                              4.r,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              currentPage.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          '/',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: const Color(
                              0xff5B4214,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          width: 100.w,
                          height: 22.w,
                          child: Row(
                            children: [
                              Text(
                                widget.popularBooksGetModel,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                'Pages',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.isShare == true
                      ? GestureDetector(
                    onTap: () async {
                      String downloadsFolderPath = '';
                      Directory? dir;

                      setState(() {
                        isLoading = true;
                      });

                      if (Platform.isAndroid) {
                        dir = await getExternalStorageDirectory();
                        downloadsFolderPath = dir?.path ?? '';
                      } else if (Platform.isIOS) {
                        dir = await getApplicationDocumentsDirectory();
                        downloadsFolderPath = dir.path ?? '';
                      }

                      if (dir != null) {
                        String fullPath = '$downloadsFolderPath/${widget.downloadBookTitle}';

                        // Check if the file exists
                        bool fileExists = File(fullPath).existsSync();

                        if (fileExists) {
                          await _listenForPermissionStatus(fullPath);
                        } else {
                          // Handle file creation or download here
                          // Example: Download the file using http package
                          await _downloadFile("https://mecca.eigix.net/public/${widget.path}", fullPath);

                          // After downloading, check permissions and share
                          await _listenForPermissionStatus(fullPath);
                        }
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Icon(
                            Icons.ios_share_rounded,
                          ),
                        )
                      : SizedBox.fromSize(),
                ],
              ),
            ),
          ),
        ),
        body: Pfile != null || !isPDFLoading
            ? PDFView(
                filePath: Pfile!.path,
                // nightMode: true,
                pageFling: true,
                fitEachPage: true,
                pageSnap:
                    false, //pages changes according to page number. like you cant swipe half way through the page.
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                onRender: (_pages) {
                  setState(() {
                    pages = _pages;
                    isReady = true;
                  });
                },

                onViewCreated: (controller) {
                  setState(() {
                    pdfViewController = controller;
                  });
                },
                onPageChanged: (int? pageNo, int? totalPages) {
                  setState(() {
                    currentPage = pageNo;
                  });
                },
                defaultPage: currentPage!,
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Color(
                    0xffE8B55B,
                  ),
                ),
              ),
      ),
    );
  }
}
