import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:custom_dialog/custom_dialog.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:location/location.dart';
import 'package:open_file/open_file.dart';

import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as Per;
import 'package:sizer/sizer.dart';

import "package:http/http.dart" as http;
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Screen/Home.dart';
import '../Helper/ApiBaseHelper.dart';
import '../Helper/Constant.dart';
import '../Helper/Session.dart';
import '../Helper/images.dart';
import 'package:path/path.dart' as path;
import 'bottom_bar.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController comController = new TextEditingController();
  TextEditingController addController = new TextEditingController();
  bool status = false;
  bool selected = false, enabled = false, edit = false;
  int activeStep = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    changePage();

    getLoc();
    getAgreement();
  }

  changePage() async {
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      status = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.5),
              colors: [
                AppColor().colorBg1(),
                AppColor().colorBg2(),
              ],
              radius: 0.8,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 7.65.h,
                width: 100.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(signUpBg),
                  fit: BoxFit.fill,
                )),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                          width: 4.h,
                          height: 4.0.h,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 5.w, top: 1.h),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                back1,
                                height: 4.0.h,
                                width: 8.w,
                              ))),
                      SizedBox(
                        width: 1.08.h,
                      ),
                      text(
                        "Sign Up",
                        textColor: Color(0xffffffff),
                        fontSize: 12.sp,
                        fontFamily: fontMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stepper(
                  currentStep: activeStep,
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NewButton(
                          selected: false,
                          width: 30.w,
                          height: 5.h,
                          textContent: activeStep == 0 ? "Back" : "Prev",
                          onPressed: () {
                            if (activeStep == 0) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                activeStep--;
                              });
                            }
                            setState(() {
                              enabled =false;
                            });
                          },
                        ),
                        NewButton(
                          selected: enabled,
                          width: 30.w,
                          height: 5.h,
                          textContent: activeStep > 2 ? "Submit" : "Next",
                          onPressed: () async {
                            if (activeStep == 0) {
                              if (validateField(nameController.text, context) !=
                                  null) {
                                setSnackbar(
                                    validateField(nameController.text, context)
                                        .toString(),
                                    context);
                                return;
                              }
                              if (validateEmail(
                                      emailController.text,
                                      "Please Enter Email",
                                      "Please Enter Valid Email") !=
                                  null) {
                                setSnackbar(
                                    validateEmail(
                                            emailController.text,
                                            "Please Enter Email",
                                            "Please Enter Valid Email")
                                        .toString(),
                                    context);
                                return;
                              }
                              if (validateMob(phoneController.text, context) !=
                                  null) {
                                setSnackbar(
                                    validateMob(phoneController.text, context)
                                        .toString(),
                                    context);
                                return;
                              }
                              if (!edit) {
                                if (addController.text.length < 12) {
                                  setSnackbar("Please Enter Address", context);
                                  return;
                                } else {
                                  await getLocationFromAdd();
                                }
                              }

                              if (validatePass(passController.text, context) !=
                                  null) {
                                setSnackbar(
                                    validatePass(passController.text, context)
                                        .toString(),
                                    context);
                                return;
                              }
                              if (passController.text != cPassController.text) {
                                setSnackbar(
                                    "Both Password Doesn't Match", context);
                                return;
                              }
                              if (comController.text == "") {
                                setSnackbar(
                                    "Commission Field Required", context);
                                return;
                              }
                              if (lat!='') {
                                setState(() {
                                  activeStep++;
                                });
                              } else {
                                setSnackbar("No Address Available", context);
                              }
                            } else if (activeStep == 1) {
                              if (sellerController.text == "") {
                                setSnackbar(
                                    "Seller Name Field Required", context);
                                return;
                              }
                              if (descController.text == "") {
                                setSnackbar(
                                    "Description  Field Required", context);
                                return;
                              }
                              if (taxNameController.text == "") {
                                setSnackbar("Tax Name Field Required", context);
                                return;
                              }
                              if (taxController.text == "") {
                                setSnackbar(
                                    "Tax Number Field Required", context);
                                return;
                              }
                              setState(() {
                                activeStep++;
                              });
                            } else if (activeStep == 2) {
                              if (panController.text.length != 10) {
                                setSnackbar("Pan Number is Not Valid", context);
                                return;
                              }
                              if (numberController.text.length < 11) {
                                setSnackbar(
                                    "Account Number is Not Valid", context);
                                return;
                              }
                              if (holderController.text == "") {
                                setSnackbar(
                                    "Account Name Field Required", context);
                                return;
                              }
                              if (codeController.text.length != 11) {
                                setSnackbar("Bank Code is Not Valid", context);
                                return;
                              }
                              if (bankController.text == "") {
                                setSnackbar(
                                    "Bank Name Field Required", context);
                                return;
                              }
                              setState(() {
                                activeStep++;
                              });
                            }else{
                              if (gstImage == null) {
                                setSnackbar(
                                    "GST Image Required", context);
                                return;
                              }
                              if (foodImage == null) {
                                setSnackbar(
                                    "Food License Image Required", context);
                                return;
                              }
                              if (proofImage == null) {
                                setSnackbar(
                                    "Identity Image Required", context);
                                return;
                              }
                              if (addressImage == null) {
                                setSnackbar(
                                    "Address Proof Image Required", context);
                                return;
                              }
                              if(!accept){
                                setSnackbar(
                                    "Please accept terms and conditions", context);
                                return;
                              }
                              setState(() {
                                enabled =true;
                              });
                              submitSubscription();
                            }
                          },
                        ),
                      ],
                    );
                  },
                  elevation: 1,
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                      title: text("Personal",
                          fontFamily: fontBold,
                          textColor: activeStep > 0
                              ? AppColor().colorPrimary()
                              : AppColor().colorTextSecondary()),
                      content: Container(
                        margin: EdgeInsets.only(top: 1.h, bottom: 3.h),
                        padding: MediaQuery.of(context).viewInsets,
                        width: 93.33.w,
                        decoration: boxDecoration(
                            radius: 50.0, bgColor: Color(0xffffffff)),
                        child: firstSign(context),
                      ),
                    ),
                    Step(
                      title: text("Seller",
                          fontFamily: fontBold,
                          textColor: activeStep > 1
                              ? AppColor().colorPrimary()
                              : AppColor().colorTextSecondary()),
                      content: Container(
                        margin: EdgeInsets.only(top: 1.h, bottom: 3.h),
                        width: 93.33.w,
                        decoration: boxDecoration(
                            radius: 50.0, bgColor: Color(0xffffffff)),
                        child: secondSign(context),
                      ),
                    ),
                    Step(
                      title: text("Bank",
                          fontFamily: fontBold,
                          textColor: activeStep > 2
                              ? AppColor().colorPrimary()
                              : AppColor().colorTextSecondary()),
                      content: Container(
                        margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                        width: 93.33.w,
                        decoration: boxDecoration(
                            radius: 50.0, bgColor: Color(0xffffffff)),
                        child: thirdSign(context),
                      ),
                    ),
                    Step(
                      title: text("Other",
                          fontFamily: fontBold,
                          textColor: activeStep > 3
                              ? AppColor().colorPrimary()
                              : AppColor().colorTextSecondary()),
                      content: Container(
                        margin: EdgeInsets.only(top: 2.h, bottom: 3.h),
                        width: 93.33.w,
                        decoration: boxDecoration(
                            radius: 50.0, bgColor: Color(0xffffffff)),
                        child: fourthSign(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 6.32.h,
        ),
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Container(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          person,
                          width: 1.04.w,
                          height: 1.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: nameController.text.length >= 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          email1,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixText: "",
                      suffixIcon:
                          validateEmail(emailController.text, "d", "d") == null
                              ? Container(
                                  width: 5.w,
                                  height: 5.w,
                                  alignment: Alignment.center,
                                  child: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: AppColor().colorPrimary(),
                                    size: 8.sp,
                                  ))
                              : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          phone,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: phoneController.text.length == 10
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 10.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.visiblePassword,
                    controller: addController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'User Address',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          location,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                          color: Color(0xffFD531F),
                        ),
                      ),
                      suffixIcon: lat != ""
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      addController.text = _address;
                      lat = _currentPosition.latitude.toString();
                      lng = _currentPosition.longitude.toString();
                      edit = true;
                    });
                  },
                  child: Container(
                    width: 80.99.w,
                    child: Row(
                      children: [
                        Image.asset(
                          "images/mark.png",
                          height: 20,
                          width: 20,
                        ),
                        text("  Use My Current Location",
                            textColor: AppColor().colorTextSecondary()),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: passController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          lock,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: passController.text.length >= 8
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: cPassController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          lock,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: cPassController.text.length > 0 &&
                              passController.text == cPassController.text
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.number,
                    controller: comController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Commission(%)',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          lock,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: comController.text.length > 0
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                text("Commission(%) to be given to the super and on order item",
                    textColor: AppColor().colorTextSecondary()),
                SizedBox(
                  height: 2.5.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.96.h,
        ),
      ],
    );
  }

  TextEditingController sellerController = new TextEditingController();
  TextEditingController urlController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController taxController = new TextEditingController();
  TextEditingController taxNameController = new TextEditingController();
  TextEditingController foodController = new TextEditingController();
  Widget secondSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 6.32.h,
        ),
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.name,
                    controller: sellerController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Seller Name',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: sellerController.text.length >= 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: false,
                    keyboardType: TextInputType.url,
                    controller: urlController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Store Url',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixText: "",
                      suffixIcon: urlController.text != ""
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
                    controller: descController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: descController.text != ""
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    controller: taxNameController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Tax Name',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixText: "",
                      suffixIcon: taxNameController.text.length >= 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
                    controller: taxController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Tax Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: taxController.text.length > 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.96.h,
        ),
      ],
    );
  }

  TextEditingController bankController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController holderController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  Widget thirdSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 6.32.h,
        ),
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
                    controller: panController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Pan Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: panController.text.length == 10
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Account Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: numberController.text.length >= 12
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    controller: holderController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Account Name',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixText: "",
                      suffixIcon: holderController.text.length >= 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
                    controller: codeController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Bank Code',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: codeController.text.length == 11
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                Container(
                  width: 80.99.w,
                  height: 7.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
                    controller: bankController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Bank Name',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      suffixIcon: bankController.text.length >= 2
                          ? Container(
                              width: 5.w,
                              height: 5.w,
                              alignment: Alignment.center,
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: AppColor().colorPrimary(),
                                size: 8.sp,
                              ))
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.96.h,
        ),
      ],
    );
  }

  File? gstImage, logoImage, proofImage, addressImage, foodImage;
  Future getImage(ImgSource source, BuildContext context, int i) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      getCropImage(context, image, i);
    });
  }
  String doc = "";
  getAgreement(){
    apiBaseHelper.postAPICall(Uri.parse("https://entemarket.com/app/v1/api/get_seller_agreement"), {}).then((value) {
          Map data = value;
          String url = data['image_url'];
          var temp = data['data'];
          if(!data['error']){
            setState(() {
              doc = "https://entemarket.com/"+temp[0]['agreement_doc'];
            });
            downloadFile(doc,"agreement.pdf");
            print("ok"+doc);
          }
    });
  }
  String filePath = "";
  downloadFile(String url, String fileName,) async {
    HttpClient httpClient = new HttpClient();
    File file;
    //String filePath = '';
    String myUrl = '';
    String dir = (await getApplicationSupportDirectory()).path;
    print("ok"+dir);
    var request = await httpClient.getUrl(Uri.parse(url),);
    var response = await request.close();
    print("ok"+response.statusCode.toString());
    if(response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      print(bytes);

      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
      //setSnackbar("Invoice Downloaded", context);
      print(file.path);
      setState(() {
        filePath = file.path;
      });

    }
    else
      filePath = 'Error code: '+response.statusCode.toString();
    try {

    }
    catch(ex){
      filePath = 'Can not fetch url';
    }}
  void getCropImage(BuildContext context, var image, int i) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      if (i == 1) {
        logoImage = croppedFile;
      }
      if (i == 2) {
        gstImage = croppedFile;
      }
      if (i == 3) {
        foodImage = croppedFile;
      }
      if (i == 4) {
        proofImage = croppedFile;
      }
      if (i == 5) {
        addressImage = croppedFile;
      }
    });
  }

  Future<void> submitSubscription(
      ) async {
    await App.init();

    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + "add_seller"),
    );
    request.files.add(
      http.MultipartFile(
        'store_logo',
        logoImage!.readAsBytes().asStream(),
        logoImage!.lengthSync(),
        filename: path.basename(logoImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.files.add(
      http.MultipartFile(
        'address_proof',
        addressImage!.readAsBytes().asStream(),
        addressImage!.lengthSync(),
        filename: path.basename(addressImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.files.add(
      http.MultipartFile(
        'national_identity_card',
        proofImage!.readAsBytes().asStream(),
        proofImage!.lengthSync(),
        filename: path.basename(proofImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.files.add(
      http.MultipartFile(
        'food_license_imgae',
        foodImage!.readAsBytes().asStream(),
        foodImage!.lengthSync(),
        filename: path.basename(foodImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.files.add(
      http.MultipartFile(
        'gst_image',
        gstImage!.readAsBytes().asStream(),
        gstImage!.lengthSync(),
        filename: path.basename(gstImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
    "name":nameController.text.toString(),
    "email":emailController.text.toString(),
    "mobile":phoneController.text.toString(),
    "password":passController.text.toString(),
    "address":addController.text.toString(),
    "store_name":sellerController.text.toString(),
    "tax_name":taxNameController.text.toString(),
    "tax_number":taxController.text.toString(),
    "status":"0",
    "commission_data":comController.text.toString(),
    "pan_number":panController.text.toString(),
    "bank_name":bankController.text.toString(),
    "bank_code":codeController.text.toString(),
    "account_name":holderController.text.toString(),
    "account_number":numberController.text.toString(),
    "store_description":descController.text.toString(),
    "store_url":urlController.text.toString(),
    "global_commission":"",
    "permissions":"",
    "categories":""
    });
    print(request.fields);
    print("request: " + request.toString());
     request.send().then((res)async {
       print("This is response:" + res.toString());
       if (res.statusCode == 200) {
         setState(() {
           enabled =false;
         });
         final respStr = await res.stream.bytesToString();
         print(respStr.toString());
         Map data = jsonDecode(respStr.toString());
         print(data);
         if(!data['error']){

           setState(() {
             setSnackbar(data['message'].toString(), context);
           });
           Navigator.pop(context);
           showDialog(
             context: context,
             builder: (context) => CustomDialog(
               content: Text(
                 'Wait for Approval',
                 style: TextStyle(
                   fontWeight: FontWeight.w900,
                   fontSize: 20.0,
                 ),
               ),
               title: Text('Registration Successful!!'),
               firstColor: Color(0xFF3CCF57),

               secondColor: Colors.white,
               headerIcon: Icon(
                 Icons.check_circle_outline,
                 size: 120.0,
                 color: Colors.white,
               ),
             ),
           );
         }else{
           setState(() {
             setSnackbar(data['message'].toString(), context);
           });
         }

       }else{
         setState(() {
           enabled =false;
         });
         final respStr = await res.stream.bytesToString();
         print(respStr.toString());
         Map data = jsonDecode(respStr.toString());
         print(data);
       }
    });

  }

  void requestPermission(BuildContext context, i) async {
    if (await Per.Permission.camera.request().isGranted) {
      getImage(ImgSource.Both, context, i);
      return;
      // Either the permission was already granted before or the user just granted it.
    }
// You can request multiple permissions at once.
    Map<Per.Permission, Per.PermissionStatus> statuses = await [
      Per.Permission.camera,
      Per.Permission.storage,
    ].request();
    if (statuses[Per.Permission.camera] == PermissionStatus.granted) {
      getImage(ImgSource.Both, context, i);
    } else {
      if (statuses[Per.Permission.camera] == PermissionStatus.denied) {
        Per.openAppSettings();
        setSnackbar("Oops you just denied the permission", context);
      }else{
        getImage(ImgSource.Both, context, i);
      }


    }
  }

  Widget fourthSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 3.32.h,
        ),
        InkWell(
          onTap: (){
            requestPermission(context, 1);
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: boxDecoration(
                bgColor: AppColor().colorEdit(), radius: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                logoImage != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("Seller Logo",
                        textColor: AppColor().colorPrimary(),
                        fontSize: 12.sp),
                    Container(
                      width: 50.w,
                      child: text(path.basename(logoImage!.path),
                          textColor: AppColor().colorTextPrimary(),
                          overFlow: true,
                          fontSize: 10.sp,maxLine: 1),
                    ),
                  ],
                )
                    : text("Add Seller Logo",
                    textColor: AppColor().colorPrimary(),
                    fontSize: 12.sp),
                logoImage != null?InkWell(
                  onTap: (){
                    showImage(logoImage);
                  },
                  child: text("View",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                ):SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
        InkWell(
          onTap: (){
            requestPermission(context, 2);
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: boxDecoration(
                bgColor: AppColor().colorEdit(), radius: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                gstImage != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("Gst Image",
                        textColor: AppColor().colorPrimary(),
                        fontSize: 12.sp),
                    Container(
                      width: 50.w,
                      child: text(path.basename(logoImage!.path),
                          textColor: AppColor().colorTextPrimary(),
                          overFlow: true,
                          fontSize: 10.sp,maxLine: 1),
                    ),
                  ],
                )
                    : text("Add Gst Image",
                    textColor: AppColor().colorPrimary(),
                    fontSize: 12.sp),
                gstImage != null
                    ?InkWell(
                  onTap: (){
                    showImage(gstImage);
                  },
                  child: text("View",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                ):SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
        InkWell(
          onTap: (){
            requestPermission(context, 3);
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: boxDecoration(
                bgColor: AppColor().colorEdit(), radius: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                foodImage != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("Food License Image",
                        textColor: AppColor().colorPrimary(),
                        fontSize: 12.sp),
                    Container(
                      width: 50.w,
                      child: text(path.basename(logoImage!.path),
                          textColor: AppColor().colorTextPrimary(),
                          overFlow: true,
                          fontSize: 10.sp,maxLine: 1),
                    ),
                  ],
                )
                    : text("Add Food License Image",
                    textColor: AppColor().colorPrimary(),
                    fontSize: 12.sp),
                foodImage != null
                    ?InkWell(
                  onTap: (){
                    showImage(foodImage);
                  },
                  child: text("View",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                ):SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
        InkWell(
          onTap: (){
            requestPermission(context, 4);
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: boxDecoration(
                bgColor: AppColor().colorEdit(), radius: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                proofImage != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("National Identity Image",
                        textColor: AppColor().colorPrimary(),
                        fontSize: 12.sp),
                    Container(
                      width: 50.w,
                      child: text(path.basename(logoImage!.path),
                          textColor: AppColor().colorTextPrimary(),
                          overFlow: true,
                          fontSize: 10.sp,maxLine: 1),
                    ),
                  ],
                )
                    : text("Add National Identity Image",
                    textColor: AppColor().colorPrimary(),
                    fontSize: 12.sp),
                proofImage != null
                    ?InkWell(
                  onTap: (){
                    showImage(proofImage);
                  },
                  child: text("View",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                ):SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
        InkWell(
          onTap: (){
            requestPermission(context, 5);
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            decoration: boxDecoration(
                bgColor: AppColor().colorEdit(), radius: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addressImage != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text("Address Proof Image",
                        textColor: AppColor().colorPrimary(),
                        fontSize: 12.sp),
                    Container(
                      width: 50.w,
                      child: text(path.basename(logoImage!.path),
                          textColor: AppColor().colorTextPrimary(),
                          overFlow: true,
                          fontSize: 10.sp,maxLine: 1),
                    ),
                  ],
                )
                    : text("Add Address Proof Image",
                    textColor: AppColor().colorPrimary(),
                    fontSize: 12.sp),
                addressImage != null
                    ?InkWell(
                  onTap: (){
                    showImage(addressImage);
                  },
                  child: text("View",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                ):SizedBox(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
        InkWell(
          onTap: (){
            setState(() {
              accept=!accept;
            });
          },
          child: Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(!accept?Icons.check_box_outline_blank:Icons.check_box,color: MyColor.primary,),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    OpenFile.open(filePath);
                  },
                  child: text("Accept terms and conditions",
                      textColor: AppColor().colorPrimary(),
                      fontSize: 12.sp),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.6.h,
        ),
      ],
    );
  }
  bool accept = false;
  showImage(File? image){
    showModalBottomSheet(context: context, builder: (BuildContext context1){
      return Container(
          width: 100.w,height:50.h ,
          padding: EdgeInsets.all(5.w),
          child: Image.file(image!,fit: BoxFit.fill,));
    });

  }
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  addUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data = {
          "email": emailController.text.trim().toString(),
          "password": passController.text.trim().toString(),
          "deviceType": Platform.isIOS ? "IOS" : "Android",
          "name": nameController.text.trim().toString(),
          "user_address": addController.text.trim().toString(),
          "latitude": lat,
          "longitude": lng,
          "phone": phoneController.text.trim().toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "register"), json.encode(data));
        print(response);
        bool status = true;
        String? msg = response['message'];
        if (response['success'] != null) {
          if (response['success']) {
            setState(() {
              selected = !selected;
            });
            setSnackbar(msg!, context);
          }
        } else {
          setState(() {
            selected = !selected;
          });
          setSnackbar(msg!, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          selected = !selected;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        selected = !selected;
      });
    }
  }

  late LocationData _currentPosition;

  late String _address = "", _dateTime;
  Location location1 = Location();
  String firstLocation = "", lat = "", lng = "";
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location1.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location1.requestService();
      if (!_serviceEnabled) {
        print('ek');
        return;
      }
    }

    _permissionGranted = await location1.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location1.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('no');
        return;
      }
    }

    location1.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      if (mounted) {
        setState(() {
          _currentPosition = currentLocation;
          print(currentLocation.latitude);

          _getAddress(_currentPosition.latitude, _currentPosition.longitude)
              .then((value) {
                if(mounted){
                  setState(() {
                    _address = "${value.first.addressLine}";
                    firstLocation = value.first.subLocality.toString();
                  });
                }

          });
        });
      }
    });
  }

  Future<List<Address>> _getAddress(double? lat, double? lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  bool addStatus = false;
  getLocationFromAdd() {
    _getAddress1(addController.text).then((value) {
      setState(() {
        _address = "${value.first.addressLine}";
        firstLocation = value.first.subLocality.toString();
        print(value.first.coordinates.latitude.toString() +
            " | " +
            value.first.coordinates.longitude.toString());
        lat = value.first.coordinates.latitude.toString();
        lng = value.first.coordinates.longitude.toString();
        if (lat != "") {
          setState(() {
            addStatus = true;
          });
        } else {
          setSnackbar("No Address Available", context);
        }
      });
    });

    return false;
  }

  Future<List<Address>> _getAddress1(String address) async {
    var add = await Geocoder.local.findAddressesFromQuery(address);
    return add;
  }
}
