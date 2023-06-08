import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../APIModels/API_Response.dart';
import '../APIModels/SignUp_LogIn_Model.dart';
import '../Services/API_Services.dart';
import 'login_screens.dart';

class ChangePassword extends StatefulWidget {
  final int otp;
  final String email;
  const ChangePassword({Key? key, required this.otp, required this.email})
      : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _changePasswordKey = GlobalKey<FormState>();
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  bool isHidden = false;
  bool isHiddenConfirm = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              30.w,
            ),
            child: Text(
              'Change Password',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 28.sp,
                color: const Color(
                  0xff5B4214,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
                vertical: 20.h,
              ),
              child: Form(
                key: _changePasswordKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 228.w,
                      height: 24.w,
                      child: Text(
                        'Please create a new password',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xff6C6C6C,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'New Password',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xff000000,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        color: const Color(
                          0xffF7F7F7,
                        ),
                      ),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide password';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: newPasswordController,
                        obscureText: isHidden,
                        keyboardType: TextInputType.visiblePassword,
                        autofocus: false,
                        cursorColor: const Color(0xffE8B55B),
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: isHidden
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Color(0xff4D4D4D),
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Color(0xff4D4D4D),
                                  ),
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/password.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.r,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xffE8B55B),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 17.h,
                            bottom: 17.h,
                            left: 19.w,
                            right: 19.w,
                          ),
                          hintText: 'Enter Password here',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xff6C6C6C,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Password',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xff000000,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        color: const Color(
                          0xffF7F7F7,
                        ),
                      ),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide password';
                          } else if (newPasswordController.text != val) {
                            return 'please provide correct password';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: confirmPasswordController,
                        obscureText: isHiddenConfirm,
                        keyboardType: TextInputType.visiblePassword,
                        autofocus: false,
                        cursorColor: const Color(0xffE8B55B),
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: isHiddenConfirm
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Color(0xff4D4D4D),
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Color(0xff4D4D4D),
                                  ),
                            onPressed: () {
                              setState(() {
                                isHiddenConfirm = !isHiddenConfirm;
                              });
                            },
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/password.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.r,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xffE8B55B),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 17.h,
                            bottom: 17.h,
                            left: 19.w,
                            right: 19.w,
                          ),
                          hintText: 'Enter Password here',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xff6C6C6C,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    isLoading
                        ? Container(
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
                                    const CircularProgressIndicator(
                                      color: Color(
                                        0xff5B4214,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
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
                                  onPressed: () => resetPassword(context),
                                  child: Text(
                                    'RESET PASSWORD',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ApiServices get service => GetIt.I<ApiServices>();

  bool isLoading = false;
  late APIResponse<List<SignUpLogInClass>> _response;
  resetPassword(BuildContext context) async {
    if (_changePasswordKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print('otp enetered successfulyy');
      Map dataOTP = {
        "email": widget.email,
        "otp": widget.otp.toString(),
        "password": newPasswordController.text,
        "confirm_password": confirmPasswordController.text,
      };
      _response = await service.updateForgetPassword(dataOTP);
      if (_response.status!.toLowerCase() == 'success') {
        print('otp enetered successfulyy ' + _response.data.toString());
        showToastSuccess(
          _response.status,
          FToast().init(context),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LogIn(),
          ),
        );
      } else {
        print('otp not enetered successfulyy');
        showToastError(
          _response.message,
          FToast().init(context),
        );
      }
    } else {
      showToastError(
        'all fields are required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
