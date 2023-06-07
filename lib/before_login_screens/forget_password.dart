import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/forgetPasswordModel.dart';
import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/API_Services.dart';
import 'ResetPasswordOTP.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(top: 23.0.h),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/buttons/back-button.svg',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 23.0.h),
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 28.sp,
                color: const Color(
                  0xff5B4214,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              30,
            ),
            child: const SizedBox(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
                vertical: 30.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/buttons/lock.svg'),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: SizedBox(
                      height: 65.h,
                      width: 222.w,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Please enter your register email to reset password.',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xff6C6C6C,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
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
                          return 'Please enter the email address';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      cursorColor: const Color(0xffE8B55B),
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          top: 17.h,
                          bottom: 17.h,
                          left: 19.w,
                          right: 19.w,
                        ),
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/email.svg',
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
                        hintText: 'Enter Email here',
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
                    height: 90.h,
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
                                  width: 7.h,
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
                                onPressed: () => forgetPassword(context),
                                child: Text(
                                  'NEXT',
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
    );
  }

  bool isLoading = false;
  late APIResponse<DataForget> _responseForget;
  ApiServices get service => GetIt.I<ApiServices>();
  forgetPassword(BuildContext context) async {
    print('object started');
    if (emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Map forgetData = {
        "email": emailController.text,
      };
      _responseForget = await service.forgetPassword(forgetData);
      print('object successful ' + _responseForget.data!.otp.toString());
      if (_responseForget.status!.toLowerCase() == 'success') {
        print(
            'object successful again ' + _responseForget.data!.otp!.toString());
        showDialog(
          builder: (context) => Dialog(
            //insetPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                15.r,
              ),
            ),
            child: SizedBox(
              width: 296.w,
              height: 390.h,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 28.w,
                  right: 28.w,
                  top: 20.h,
                  bottom: 14.h,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      child: SvgPicture.asset('assets/images/pop_up.svg'),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SvgPicture.asset('assets/images/pass_next.svg'),
                    SizedBox(
                      height: 20.h,
                    ),
                    SvgPicture.asset('assets/images/code_sent.svg'),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
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
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordOTP(
                                  otpData: _responseForget.data!.otp!,
                                  emailData: emailController.text,
                                ),
                              ),
                            ),
                            child: Text(
                              'OK',
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
          context: context,
        );
      } else {
        print('object failed' + forgetData.toString());
        showToastError(
          'experiencing technical issue!',
          FToast().init(context),
        );
      }
    } else {
      showToastError(
        'email is required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
