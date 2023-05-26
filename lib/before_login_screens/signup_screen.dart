import 'package:MeccaIslamicCenter/APIModels/API_Response.dart';
import 'package:MeccaIslamicCenter/APIModels/SignUp_LogIn_Model.dart';
import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
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

  bool isHidden = false;
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
              10,
            ),
            child: SizedBox(
              width: 109,
              height: 42,
              child: Text(
                'Sign Up',
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
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 20,
              ),
              child: Form(
                key: _signUpKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'First Name',
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
                          fontSize: 12,
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
                              12,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xffE8B55B),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(top: 18, bottom: 0.0),
                          hintText: 'Enter Name here',
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
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Last Name',
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
                          fontSize: 12,
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
                              12,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xffE8B55B),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(top: 18, bottom: 0.0),
                          hintText: 'Enter Name here',
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
                      height: 25,
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
                          contentPadding:
                              const EdgeInsets.only(top: 16, bottom: 0.0),
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
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
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
                          fontSize: 12,
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
                              12,
                            ),
                            borderSide: const BorderSide(
                              color: Color(0xffE8B55B),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.only(top: 18, bottom: 0.0),
                          hintText: 'Enter Password here',
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
                      height: 50,
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
                                  onPressed: () => signInButton(context),
                                  child: Text(
                                    'SIGN UP',
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
                    const SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: 265,
                      height: 27,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
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
                                fontSize: 16,
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
          _responseSignIn.message,
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
