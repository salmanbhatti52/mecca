import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ReadBook extends StatefulWidget {
  final String popularBooksGetModel;
  String? path;

  ReadBook({Key? key, required this.popularBooksGetModel, this.path})
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
  int? currentPage = 1;
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
            111,
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
              padding: const EdgeInsets.only(
                top: 63.0,
                bottom: 40,
                left: 24,
                right: 20,
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
                    width: 97,
                  ),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            side: const BorderSide(
                              color: Color(
                                0xffE8B55B,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: 343,
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 150,
                                    // color: Colors.red,
                                    child: AutoSizeText(
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      minFontSize: 12,
                                      'Enter the page number you want to go to',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(
                                          0xff5B4214,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 50,
                                    child: TextField(
                                      onChanged: (val) {
                                        setState(() {
                                          pdfViewController
                                              .setPage(int.parse(val));
                                          print('page jump ' +
                                              currentPage.toString());
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      keyboardType: TextInputType.number,
                                      cursorColor: const Color(
                                        0xffE8B55B,
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(
                                          0xff5B4214,
                                        ),
                                      ),
                                      decoration: const InputDecoration(
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
                          width: 21,
                          height: 21,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xff5B4214,
                            ),
                            borderRadius: BorderRadius.circular(
                              4,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              currentPage.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '/',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(
                              0xff5B4214,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 120,
                          height: 22,
                          child: Row(
                            children: [
                              Text(
                                widget.popularBooksGetModel,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(
                                    0xff5B4214,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              Text(
                                'Pages',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
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
