import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../APIModels/API_Response.dart';
import '../APIModels/forgetPasswordModel.dart';
import '../Services/API_Services.dart';
import '../Utilities/showToast.dart';
import 'changePassword.dart';

class ResetPasswordOTP extends StatefulWidget {
  final int otpData;
  final String emailData;
  const ResetPasswordOTP({
    Key? key,
    required this.otpData,
    required this.emailData,
  }) : super(key: key);

  @override
  State<ResetPasswordOTP> createState() => _ResetPasswordOTPState();
}

class _ResetPasswordOTPState extends State<ResetPasswordOTP> {
  bool isSubmitted = false;
  String userTypedOtp = '';
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 120;
  bool isTimerCompleted = false;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            isTimerCompleted = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (mounted) startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              30,
            ),
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 28,
                color: const Color(
                  0xff5B4214,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 40,
                  // ),
                  SvgPicture.asset('assets/images/reset_text.svg'),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 90,
                        child: Text(
                          timerText,
                          style: GoogleFonts.poppins(
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                            color: const Color(
                              0xff00B900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OtpTextField(
                    fieldWidth: 56,
                    cursorColor: const Color(
                      0xffE8B55B,
                    ),
                    clearText: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textStyle: GoogleFonts.outfit(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      fillColor: const Color(0xffF7F7F7),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        borderSide: const BorderSide(
                          color: Color(0xffF7F7F7),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        borderSide: const BorderSide(
                          color: Color(
                            0xffF7F7F7,
                          ),
                        ),
                      ),
                      focusColor: const Color(
                        0xffF7F7F7,
                      ),
                      hintText: '-',
                      hintStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: const Color(
                          0xff6C6C6C,
                        ),
                      ),
                    ),
                    numberOfFields: 4,
                    hasCustomInputDecoration: true,
                    onCodeChanged: (String code) {
                      setState(() {
                        isSubmitted = false;
                        userTypedOtp = '';
                      });
                    },
                    onSubmit: (String verificationCode) {
                      setState(() {
                        isSubmitted = true;
                        userTypedOtp = verificationCode;
                      });
                    }, // end onSubmit
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  SizedBox(
                    // color: Colors.red,
                    width: !isTimerCompleted || !isLoading ? 300 : 180,
                    height: isLoading ? 60 : 30,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE8B55B),
                            ),
                          )
                        : TextButton(
                            onPressed: () =>
                                isTimerCompleted ? resendCode(context) : null,
                            style: const ButtonStyle(
                              visualDensity: VisualDensity.compact,
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: MaterialStatePropertyAll(
                                Color(
                                  0xffF7F7F7,
                                ),
                              ),
                              shadowColor: MaterialStatePropertyAll(
                                Color(
                                  0xff6C6C6C,
                                ),
                              ),
                            ),
                            child: Text(
                              (isTimerCompleted || isLoading)
                                  ? 'Resend Verification Code'
                                  : 'We\'ve sent you a 4 digit verification code',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xff6C6C6C,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
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
                          onPressed: () => nextPage(context),
                          child: Text(
                            'NEXT',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  nextPage(BuildContext context) {
    if (!isSubmitted && userTypedOtp == '') {
      showToastError('Enter OTP', FToast().init(context));
    } else {
      if (userTypedOtp == widget.otpData.toString()) {
        showToastSuccess(userTypedOtp, FToast().init(context));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePassword(
              otp: widget.otpData,
              email: widget.emailData,
            ),
          ),
        );
      } else {
        showToastError('otp does not match', FToast().init(context));
      }
    }
  }

// resend otp api implementation!

  bool isLoading = false;
  late APIResponse<DataForget> _responseForget;
  ApiServices get service => GetIt.I<ApiServices>();
  resendCode(BuildContext context) async {
    print('object started');

    setState(() {
      isLoading = true;
    });
    Map forgetData = {
      "email": widget.emailData,
    };
    _responseForget = await service.forgetPassword(forgetData);
    print('object successful ' + _responseForget.data!.otp.toString());
    if (_responseForget.status!.toLowerCase() == 'success') {
      print('object successful again ' + _responseForget.data!.otp!.toString());
      if (mounted) startTimeout();
    } else {
      print('object failed' + forgetData.toString());
      showToastError(
        _responseForget.message,
        FToast().init(context),
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}
