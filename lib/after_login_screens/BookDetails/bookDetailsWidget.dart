import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../APIModels/API_Response.dart';
import '../../APIModels/RelatedBooksModel.dart';
import '../../APIModels/book_view.dart';
import '../../Services/API_Services.dart';
import '../../Utilities/showToast.dart';

class BookDetailsWidget extends StatefulWidget {
  final RelatedBooksModel relatedBooksModel;

  const BookDetailsWidget({
    Key? key,
    required this.relatedBooksModel,
  }) : super(key: key);

  @override
  State<BookDetailsWidget> createState() => _BookDetailsWidgetState();
}

class _BookDetailsWidgetState extends State<BookDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      height: 310.w,
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
                      'https://mecca.eigix.net/public/${widget.relatedBooksModel.cover}',
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
                  child: isAdding
                      ? SizedBox(
                          width: 20.w,
                          height: 25.h,
                          child: CircularProgressIndicator(
                            color: Color(0xffE8B55B),
                            strokeWidth: 0.9,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => featuredBookBookmark(context),
                          child: SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: SvgPicture.asset(
                                'assets/buttons/save.svg',
                                // fit: BoxFit.scaleDown,
                              )),
                        ),
                ),
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
                    widget.relatedBooksModel.title!,
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
            //   height: 3,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.red,
                  width: 120.w,
                  height: 20.w,
                  child: AutoSizeText(
                    maxLines: 2,
                    minFontSize: 10,
                    widget.relatedBooksModel.author!.name!,
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
            //   height: 1,
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
                      widget.relatedBooksModel.category!.name!,
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
      ),
    );
  }

  ApiServices get service => GetIt.I<ApiServices>();
  late APIResponse<BookViewModel> _responseAddBookMark;
  bool isAdding = false;
  featuredBookBookmark(BuildContext context) async {
    setState(() {
      isAdding = true;
    });
    Map addData = {
      "users_customers_id": "41",
      "books_id": "1",
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
}
