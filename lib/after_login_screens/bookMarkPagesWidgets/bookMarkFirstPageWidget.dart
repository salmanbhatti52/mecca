import 'package:MeccaIslamicCenter/APIModels/all_bookmarked_books.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class BookMarkFirstPageWidget extends StatefulWidget {
  final AllBooksBookMarked allBooksBookMarked;
  final VoidCallback function;
  final bool isRemoving;
  final int index;
  final int currentIndex;
  const BookMarkFirstPageWidget({
    Key? key,
    required this.allBooksBookMarked,
    required this.function,
    required this.isRemoving,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<BookMarkFirstPageWidget> createState() =>
      _BookMarkFirstPageWidgetState();
}

class _BookMarkFirstPageWidgetState extends State<BookMarkFirstPageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  late SecureSharedPref secureSharedPref;
  int userID = -1;
  init() async {
    secureSharedPref = await SecureSharedPref.getInstance();
    userID = (await secureSharedPref.getInt('userID')) ?? -1;

    print(
      'id collected successfully on remove bookmark ' + userID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "pag numbers of books " + widget.allBooksBookMarked.pages!.toString());
    return Container(
      width: 165.w,
      height: 330.h,
      decoration: BoxDecoration(
        color: const Color(
          0xffF7F7F7,
        ),
        // color: Colors.red,
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 5.h,
          left: 5.w,
          right: 5.w,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                  child: SizedBox(
                    width: 146.w,
                    height: 152.w,
                    child: Image.network(
                      'https://mecca.eigix.net/public/${widget.allBooksBookMarked.cover}',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          child: Image.asset(
                              'assets/images/placeholder_image.png'),
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xffE8B55B),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                      onTap: widget.function,
                      child: SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: widget.currentIndex == widget.index
                              ? widget.isRemoving
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 25.h,
                                      child: const CircularProgressIndicator(
                                        color: Color(0xffE8B55B),
                                        strokeWidth: 0.9,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      'assets/buttons/save.svg',
                                      colorFilter: const ColorFilter.mode(
                                          Color(
                                            0xff00B900,
                                          ),
                                          BlendMode.srcIn),
                                      // fit: BoxFit.scaleDown,
                                    )
                              : SvgPicture.asset(
                                  'assets/buttons/save.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Color(
                                        0xff00B900,
                                      ),
                                      BlendMode.srcIn),
                                  // fit: BoxFit.scaleDown,
                                ))),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.red,
                    width: 120.w,
                    height: 50.h,
                    child: AutoSizeText(
                      maxLines: 3,
                      minFontSize: 10,
                      widget.allBooksBookMarked.title!,
                      // 'amin of this app who controls it  amin of this app who controls ',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(
                          0xff000000,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 6.h,
            // ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    // maxLines: 2,
                    // minFontSize: 10,
                    'Author',
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(
                        0xff316F94,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 2.h,
            // ),

            //testing purpose 12345
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.red,
                    width: 120.w,
                    height: 20.h,
                    child: AutoSizeText(
                      maxLines: 2,
                      minFontSize: 10,
                      widget.allBooksBookMarked.author?.name ?? "author?.name" ,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(
                          0xff5B4214,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 1,
            // ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    // maxLines: 2,
                    // minFontSize: 10,
                    'Category',
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(
                        0xff00B900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 6.h,
            // ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 6.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        // maxLines: 2,
                        // minFontSize: 10,
                        widget.allBooksBookMarked.category!.name!,
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xff5B4214,
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
    );
  }
}
