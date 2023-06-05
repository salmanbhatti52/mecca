import 'package:MeccaIslamicCenter/APIModels/popular_books_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../Services/API_Services.dart';

class FeaturedBooksWidget extends StatefulWidget {
  final VoidCallback function;
  final PoplarBooksModel popularBooksGetModel;
  final bool isAdding;
  const FeaturedBooksWidget(
      {Key? key,
      required this.popularBooksGetModel,
      required this.function,
      required this.isAdding})
      : super(key: key);

  @override
  State<FeaturedBooksWidget> createState() => _FeaturedBooksWidgetState();
}

class _FeaturedBooksWidgetState extends State<FeaturedBooksWidget> {
  ApiServices get service => GetIt.I<ApiServices>();

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
      'id collected successfully on featured widget ' + userID.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 310,
      decoration: BoxDecoration(
        color: const Color(
          0xffF7F7F7,
        ),
        // color: Colors.red,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          left: 5,
          right: 5,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  child: SizedBox(
                    width: 146,
                    height: 152,
                    child: Image.network(
                      'https://mecca.eigix.net/public/${widget.popularBooksGetModel.cover}',
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
                  child: widget.isAdding
                      ? const SizedBox(
                          width: 20,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Color(0xffE8B55B),
                            strokeWidth: 0.9,
                          ),
                        )
                      : GestureDetector(
                          onTap: widget.function,
                          // featuredBookBookmark(context,
                          // widget.popularBooksGetModel.books_id!.toString()),
                          child: SizedBox(
                            height: 20,
                            width: 20,
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
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.red,
                  width: 110,
                  height: 32,
                  child: AutoSizeText(
                    maxLines: 3,
                    minFontSize: 9,
                    widget.popularBooksGetModel.title!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(
                        0xff000000,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  // maxLines: 2,
                  // minFontSize: 10,
                  'Author',
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    color: const Color(
                      0xff316F94,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.red,
                  width: 120,
                  height: 20,
                  child: AutoSizeText(
                    maxLines: 2,
                    minFontSize: 10,
                    widget.popularBooksGetModel.author!.name!,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(
                        0xff5B4214,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AutoSizeText(
                  // maxLines: 2,
                  // minFontSize: 10,
                  'Category',
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    color: const Color(
                      0xff00B900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    // maxLines: 2,
                    // minFontSize: 10,
                    widget.popularBooksGetModel.category!.name!,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
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
    );
  }
}
