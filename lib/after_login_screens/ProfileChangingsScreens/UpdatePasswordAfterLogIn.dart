import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../APIModels/API_Response.dart';
import '../../APIModels/SignUp_LogIn_Model.dart';
import '../../Services/API_Services.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHiddenOld = false;
  bool isHiddenNew = false;
  bool isHiddenNewPassword = false;

  late SecureSharedPref secureSharedPref;
  // int userID = -1;
  String userEmail = '';
  ApiServices get service => GetIt.I<ApiServices>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    secureSharedPref = await SecureSharedPref.getInstance();
    userEmail = (await secureSharedPref.getString('userEmail')) ?? '';

    print(
      'email collected successfully at last ' + userEmail,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newPasswordController.dispose();
    oldPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70.w,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 25.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                // stops: [
                //   0.72,
                //   0.31,
                //   0.03,
                // ],
                colors: [
                  Color(
                    0xffF7E683,
                  ),
                  Color(
                    0xffE8B55B,
                  ),
                ],
              ),
            ),
            child: Center(
              child: Text(
                'Profile',
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: const Color(0xffE8B55B),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 28.0.h,
                          left: 25.w,
                          right: 25.w,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 160.w,
                                    height: 30.w,
                                    child: Text(
                                      'Update Profile',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(
                                          0xff000000,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Old Password',
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
                                height: 7.h,
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: oldPasswordController,
                                  obscureText: isHiddenOld,
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
                                      icon: isHiddenOld
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
                                          isHiddenOld = !isHiddenOld;
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
                                      bottom: 7.h,
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
                                height: 7.h,
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: newPasswordController,
                                  obscureText: isHiddenNew,
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
                                      icon: isHiddenNew
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
                                          isHiddenNew = !isHiddenNew;
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
                                      bottom: 7.h,
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
                                height: 17.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirm New Password',
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
                                height: 7.h,
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
                                    } else if (newPasswordController.text !=
                                        val) {
                                      return 'please provide correct password';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: confirmNewPasswordController,
                                  obscureText: isHiddenNewPassword,
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
                                      icon: isHiddenNewPassword
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
                                          isHiddenNewPassword =
                                              !isHiddenNewPassword;
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
                                      bottom: 7.h,
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
                                height: 30.h,
                              ),
                              isUpdating
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(
                                          0xffE8B55B,
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
                                          width: 237.w,
                                          height: 37.h,
                                          child: MaterialButton(
                                            focusColor: const Color(0xffF7E683),
                                            splashColor:
                                                const Color(0xffF7E683),
                                            onPressed: () {
                                              updateAccount(context);
                                            },
                                            child: Text(
                                              'UPDATE',
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
                              Container(
                                width: double.infinity,
                                height: 63.h,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xffE96B6B,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    12.r,
                                  ),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 237.w,
                                    height: 37.h,
                                    child: MaterialButton(
                                      focusColor: const Color(0xffF7E683),
                                      splashColor: const Color(0xffF7E683),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              builder: (context, setState) {
                                            return Dialog(
                                              //insetPadding: EdgeInsets.zero,
                                              alignment: Alignment.center,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15.r,
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: 338.w,
                                                height: 345.h,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 24.w,
                                                    right: 24.w,
                                                    top: 20.h,
                                                    bottom: 15.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Delete Account?',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 28.sp,
                                                          color: const Color(
                                                            0xff5B4214,
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      SizedBox(
                                                        width: 216.w,
                                                        height: 64.w,
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          'Are you sure you want to     delete you account?',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                              0xff000000,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        width: 282.w,
                                                        height: 63.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color(
                                                                0xffF7E683,
                                                              ),
                                                              Color(
                                                                0xffE8B55B,
                                                              ),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            12.r,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: SizedBox(
                                                            width: 237.w,
                                                            height: 37.h,
                                                            child:
                                                                MaterialButton(
                                                              focusColor:
                                                                  const Color(
                                                                      0xffF7E683),
                                                              splashColor:
                                                                  const Color(
                                                                      0xffF7E683),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'NO',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      const Color(
                                                                    0xff5B4214,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      isDeleting
                                                          ? Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 63.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xffE96B6B),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  12.h,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'PLEASE WAIT',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            18.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    const CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 63.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xffE96B6B),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  12.r,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 37.h,
                                                                  child:
                                                                      MaterialButton(
                                                                    focusColor:
                                                                        const Color(
                                                                            0xffF7E683),
                                                                    splashColor:
                                                                        const Color(
                                                                            0xffF7E683),
                                                                    onPressed:
                                                                        () {
                                                                      deleteAccount(
                                                                          context,
                                                                          setState);
                                                                    },
                                                                    child: Text(
                                                                      'YES',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            18.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .white,
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
                                            );
                                          }),
                                        );
                                      },
                                      child: Text(
                                        'DELETE ACCOUNT',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
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
        ),
      ),
    );
  }

  bool isUpdating = false;
  late APIResponse<SignUpLogInClass> _responseUpdate;
  updateAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print('permission granted');
      setState(() {
        isUpdating = true;
      });
      Map updateData = {
        "email": userEmail,
        "old_password": oldPasswordController.text,
        "password": newPasswordController.text,
        "confirm_password": confirmNewPasswordController.text
      };
      print('fields get done ' + updateData.toString());
      _responseUpdate = await service.updatePassword(updateData);
      print('fields get done now getting data ' + updateData.toString());
      if (_responseUpdate.status!.toLowerCase() == 'success') {
        print('operation successful ' + updateData.toString());
        showToastSuccess(
          'password updates successfully',
          FToast().init(context),
        );
      } else {
        print('fields havent get done ' + updateData.toString());
        showToastError(
          _responseUpdate.message,
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
      isUpdating = false;
    });
  }

  bool isDeleting = false;
  late APIResponse _responseDelete;
  deleteAccount(BuildContext context, StateSetter setState) async {
    print('delete operation started ');
    setState(() {
      isDeleting = true;
    });
    Map deleteData = {
      "user_email": userEmail,
      "delete_reason": "test delete",
      "comments": "Hello"
    };
    print('fields get done for delete' + deleteData.toString());
    _responseDelete = await service.deleteAccount(deleteData);
    print('fields get done for delete now deleting' + deleteData.toString());
    if (_responseDelete.status!.toLowerCase() == 'success') {
      print('entered the safe zone' + deleteData.toString());
      showToastSuccess(
        _responseDelete.status,
        FToast().init(context),
      );
    } else {
      print('enetered the red zone' + deleteData.toString());
      print(_responseDelete.message.toString());
      showToastError(
        _responseDelete.message,
        FToast(),
      );
    }
    setState(() {
      isDeleting = false;
    });
  }
}
