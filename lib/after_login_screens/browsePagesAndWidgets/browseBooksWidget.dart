import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class BrowseBooksWidget extends StatefulWidget {
  final PoplarBooksModel popularBooksGetModel;
  final VoidCallback function;
  final bool isAdding;
  final int index;
  final int currentIndex;
  const BrowseBooksWidget(
      {Key? key,
      required this.popularBooksGetModel,
      required this.function,
      required this.isAdding,
      required this.index,
      required this.currentIndex})
      : super(key: key);

  @override
  State<BrowseBooksWidget> createState() => _BrowseBooksWidgetState();
}

class _BrowseBooksWidgetState extends State<BrowseBooksWidget> {
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
      'id collected successfully on top widget ' + userID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5.h,
        left: 5.w,
        right: 5.w,
      ),
      width: 165.w,
      height: 315.h,
      decoration: BoxDecoration(
        color: const Color(
          0xffF7F7F7,
        ),
        // color: Colors.red,
        borderRadius: BorderRadius.circular(
          10.r,
        ),
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
                  height: 152.h,
                  child: Image.network(
                    'https://mecca.eigix.net/public/${widget.popularBooksGetModel.cover}',
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Container(
                        child:
                            Image.asset('assets/images/placeholder_image.png'),
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
                  child: widget.currentIndex == widget.index
                      ? widget.isAdding
                          ? SizedBox(
                              width: 20.w,
                              height: 25.h,
                              child: CircularProgressIndicator(
                                color: Color(0xffE8B55B),
                                strokeWidth: 0.9,
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.function,
                              child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: widget.popularBooksGetModel.bookmarked!
                                            .toLowerCase() ==
                                        'yes'
                                    ? SvgPicture.asset(
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
                                        // fit: BoxFit.scaleDown,
                                      ),
                              ),
                            )
                      : GestureDetector(
                          onTap: widget.function,
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: widget.popularBooksGetModel.bookmarked!
                                        .toLowerCase() ==
                                    'yes'
                                ? SvgPicture.asset(
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
                                    // fit: BoxFit.scaleDown,
                                  ),
                          ),
                        )),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // color: Colors.red,
                width: 110.w,
                height: 32.h,
                child: AutoSizeText(
                  maxLines: 3,
                  minFontSize: 9,
                  widget.popularBooksGetModel.title!,
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
          SizedBox(
            height: 3.h,
          ),
          Row(
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
          // SizedBox(
          //   height: 2.h,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // color: Colors.red,
                width: 120.w,
                height: 20.h,
                child: AutoSizeText(
                  maxLines: 2,
                  minFontSize: 10,
                  widget.popularBooksGetModel.author!.name!,
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
          // const SizedBox(
          //   height: 1,
          // ),
          Row(
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
          // SizedBox(
          //   height: 4.h,
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    // maxLines: 2,
                    // minFontSize: 10,
                    widget.popularBooksGetModel.category!.name!,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(
                        0xff5B4214,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
