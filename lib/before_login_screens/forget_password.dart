import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/forgetPasswordModel.dart';
import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.only(top: 23.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/buttons/back-button.svg',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 23.0),
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              30,
            ),
            child: SizedBox(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/buttons/lock.svg'),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: SizedBox(
                        height: 48,
                        width: 222,
                        child: Text(
                          'Please enter your register email to reset password.',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(
                              0xff6C6C6C,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xff000000,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: 337,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        12,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 16, bottom: 0.0),
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/email.svg',
                          fit: BoxFit.scaleDown,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xffE8B55B),
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Email here',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(
                            0xff6C6C6C,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  isLoading
                      ? Container(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'PLEASE WAIT',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(
                                      0xff5B4214,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
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
                                onPressed: () => forgetPassword(context),
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
          context: context,
          builder: (context) => Dialog(
            //insetPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: SizedBox(
              width: 296,
              height: 390,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 28,
                  right: 28,
                  top: 20,
                  bottom: 14,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      child: SvgPicture.asset('assets/images/pop_up.svg'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset('assets/images/pass_next.svg'),
                    const SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset('assets/images/code_sent.svg'),
                    const SizedBox(
                      height: 20,
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
        );
      } else {
        print('object failed' + forgetData.toString());
        showToastError(
          _responseForget.message,
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
