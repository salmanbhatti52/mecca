import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/SignUp_LogIn_Model.dart';
import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/API_Services.dart';
import 'login_screens.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  late TextEditingController firstnameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstnameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstnameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool isHidden = true;
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
              20.w,
            ),
            child: SizedBox(
              width: 109.w,
              height: 42.w,
              child: Text(
                'Sign Up',
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
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
                vertical: 20.h,
              ),
              child: Form(
                key: _signUpKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'First Name',
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
                            return 'Please enter fisrt name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: firstnameController,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        cursorColor: const Color(0xffE8B55B),
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/person.svg',
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
                          hintText: 'Enter Name here',
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
                          'Last Name',
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
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        cursorColor: const Color(0xffE8B55B),
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/person.svg',
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
                          hintText: 'Enter Name here',
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
                          contentPadding: EdgeInsets.only(
                            top: 17.h,
                            bottom: 17.h,
                            left: 19.w,
                            right: 19.w,
                          ),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      height: 50.h,
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
                                    width: 7.w,
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
                                  onPressed: () => signInButton(context),
                                  child: Text(
                                    'SIGN UP',
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
                      height: 60.h,
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
                                  builder: (context) => const LogIn(),
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
                              'Login',
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

  ApiServices get service => GetIt.I<ApiServices>();
  late APIResponse<SignUpLogInClass> _responseSignIn;
  bool isLoading = false;
  signInButton(BuildContext context) async {
    print('object started ');
    if (_signUpKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map signUpData = {
        "first_name": firstnameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "account_type": "SignupWithApp",
        "one_signal_id": "123456"
      };
      _responseSignIn = await service.signUpAPI(signUpData);
      print('object ' + signUpData.toString());
      if (_responseSignIn.status!.toLowerCase() == 'success') {
        print('success099 ' + signUpData.toString());
        showToastSuccess(
          _responseSignIn.status,
          FToast().init(context),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LogIn(),
          ),
        );
      } else {
        print(
          'failure in sign in ' +
              signUpData.toString() +
              _responseSignIn.message.toString(),
        );
        showToastError(
          'experiencing technical issue!',
          FToast().init(context),
        );
      }
    } else {
      showToastError(
        'All fields are required',
        FToast().init(context),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
