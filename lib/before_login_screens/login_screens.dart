import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/SignUp_LogIn_Model.dart';
import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:MeccaIslamicCenter/before_login_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../Services/API_Services.dart';
import '../bottomNavigatorBar.dart';
import 'forget_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool isHidden = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    init();
  }

  bool isLoadingStart = false;
  late SecureSharedPref prefs;

  init() async {
    setState(() {
      isLoadingStart = true;
    });
    prefs = await SecureSharedPref.getInstance();
    setState(() {
      isLoadingStart = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: isLoadingStart
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                // resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 18.w,
                      right: 18.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Form(
                      key: _logInKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                            width: 146.w,
                            height: 117.h,
                            child: SvgPicture.asset(
                              'assets/images/islamic_center.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(
                            height: 61.h,
                          ),
                          SizedBox(
                            width: 159.w,
                            height: 30.w,
                            child: Text(
                              'Welcome Back!',
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xff00B900,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 78.w,
                            height: 46.w,
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(
                                  0xff000000,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/email.svg',
                                  fit: BoxFit.scaleDown,
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 17.h,
                                  bottom: 17.h,
                                  left: 19.w,
                                  right: 19.w,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    16.r,
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
                            height: 25.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
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
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
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
                                contentPadding: EdgeInsets.only(
                                  top: 17.h,
                                  bottom: 17.h,
                                  left: 19.w,
                                  right: 19.w,
                                ),

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
                                // fillColor: const Color(0xffF7F7F7),
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
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(
                                //     12,
                                //   ),
                                //
                                //   // borderSide: BorderSide(
                                //   //   color: Color(
                                //   //     0xffF7F7F7,
                                //   //   ),
                                //   // ),
                                // ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
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
                                onPressed: () async {
                                  // await Future.delayed(
                                  //   Duration(
                                  //     seconds: 5,
                                  //   ),
                                  // );
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forget Password?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(
                                      0xff6C6C6C,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35.h,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  width: 337.w,
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
                                        onPressed: () => logInButton(context),
                                        child: Text(
                                          'LOGIN',
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
                          SizedBox(
                            height: 30.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 27.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don’t have an account?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(
                                      0xff000000,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const SignUp(),
                                      ),
                                    );
                                  },
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
                                    'Sign Up',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(
                                        0xff00B900,
                                      ),
                                    ),
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
              ),
      ),
    );
  }

  bool isLoading = false;
  late APIResponse<SignUpLogInClass> _responseLogIn;
  ApiServices get service => GetIt.I<ApiServices>();
  logInButton(BuildContext context) async {
    if (_logInKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map logInData = {
        "email": emailController.text,
        "password": passwordController.text,
        "one_signal_id": "123456"
      };
      _responseLogIn = await service.logInAPI(logInData);

      if (_responseLogIn.status!.toLowerCase() == 'success') {
        await prefs.putInt(
          'userID',
          _responseLogIn.data!.users_customers_id!,
        );
        await prefs.putString('userEmail', _responseLogIn.data!.email!);
        await prefs.putString('isLogin', 'true');
        showToastSuccess(
          'login successful',
          FToast().init(context),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreens(),
          ),
        );
      } else {
        showToastError(
          _responseLogIn.message.toString(),
          FToast().init(context),
        );
      }
      setState(() {
        isLoading = false;
      });
    } else {
      showToastError(
        'All fields are required',
        FToast().init(context),
      );
    }
  }
}
