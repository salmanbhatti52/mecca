import 'package:MeccaIslamicCenter/APIModels/category_model_get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesWidget extends StatefulWidget {
  final CategoryGetModel categoryGetModel;
  const CategoriesWidget({Key? key, required this.categoryGetModel})
      : super(key: key);

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: 78,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ),
        gradient: widget.categoryGetModel.isCategorySelected!
            ? const LinearGradient(
                colors: [
                  Color(
                    0xffF7E683,
                  ),
                  Color(
                    0xffE8B55B,
                  ),
                ],
              )
            : const LinearGradient(
                colors: [
                  Color(
                    0xffF7F7F7,
                  ),
                  Color(
                    0xffF7F7F7,
                  ),
                ],
              ),
      ),
      child: Center(
        child: Text(
          widget.categoryGetModel.name!,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(
              0xff5B4214,
            ),
          ),
        ),
      ),
    );
  }
}
