import 'package:MeccaIslamicCenter/Utilities/showToast.dart';
import 'package:flutter/material.dart';
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
            70,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 25),
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
                        padding: const EdgeInsets.only(
                          top: 28.0,
                          left: 25,
                          right: 25,
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
                                    width: 160,
                                    height: 30,
                                    child: Text(
                                      'Update Profile',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(
                                          0xff000000,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Old Password',
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
                                height: 7,
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
                                    fontSize: 12,
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
                                        12,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE8B55B),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        top: 18, bottom: 0.0),
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
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Password',
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
                                height: 7,
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
                                    fontSize: 12,
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
                                        12,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE8B55B),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        top: 18, bottom: 0.0),
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
                                height: 17,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirm New Password',
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
                                height: 7,
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
                                    fontSize: 12,
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
                                        12,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE8B55B),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        top: 18, bottom: 0.0),
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
                                height: 30,
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
                                            splashColor:
                                                const Color(0xffF7E683),
                                            onPressed: () {
                                              updateAccount(context);
                                            },
                                            child: Text(
                                              'UPDATE',
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
                                height: 30,
                              ),
                              Container(
                                width: 337,
                                height: 63,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xffE96B6B,
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
                                                  15,
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: 338,
                                                height: 345,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 24,
                                                    right: 24,
                                                    top: 28,
                                                    bottom: 30,
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
                                                          fontSize: 28,
                                                          color: const Color(
                                                            0xff5B4214,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SvgPicture.asset(
                                                          'assets/images/dlt_text.svg'),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      Container(
                                                        width: 282,
                                                        height: 63,
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
                                                            12,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: SizedBox(
                                                            width: 237,
                                                            height: 37,
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
                                                                  fontSize: 18,
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
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      isDeleting
                                                          ? Container(
                                                              width: 282,
                                                              height: 63,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xffE96B6B),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  12,
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
                                                                            18,
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
                                                              width: 282,
                                                              height: 63,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xffE96B6B),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  12,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: SizedBox(
                                                                  width: 237,
                                                                  height: 37,
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
                                                                            18,
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
                                          fontSize: 18,
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
