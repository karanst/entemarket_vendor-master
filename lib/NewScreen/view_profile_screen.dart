import 'package:animated_widgets/animated_widgets.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/NewScreen/edit_profile_screen.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController addController = new TextEditingController();
  //bool status = false;
  bool selected = false, enabled = false, edit1 = false;
  String? name,
      email,
      mobile,
      address,
      image,
      curPass,
      newPass,
      confPass,
      loaction,
      accNo,
      storename,
      storeurl,
      storeDesc,
      accname,
      bankname,
      bankcode,
      latitutute,
      longitude,
      taxname,
      taxnumber,
      pannumber,
      status,
      storelogo;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    getUserDetails();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      CUR_USERID = prefs.getString(Id);
      mobile = prefs.getString(Mobile);
      name = prefs.getString(Username);
      email = prefs.getString(Email);
      address = prefs.getString(Address);
      image = prefs.getString(IMage);
      CUR_USERID = prefs.getString(Id);
      mobile = prefs.getString(Mobile);
      storename = prefs.getString(Storename);
      storeurl = prefs.getString(Storeurl);
      storeDesc = prefs.getString(storeDescription);
      accNo = prefs.getString(accountNumber);
      accname = prefs.getString(accountName);
      bankcode = prefs.getString(bankCode);
      bankname = prefs.getString(bankName);
      latitutute = prefs.getString(Latitude);
      longitude = prefs.getString(Longitude);
      taxname = prefs.getString(taxName);
      taxnumber = prefs.getString(taxNumber);
      pannumber = prefs.getString(panNumber);
      status = prefs.getString(STATUS);
      storelogo = prefs.getString(StoreLogo);
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
      backgroundColor: AppColor().colorBg1(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg1(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 18.h),
                  width: 99.33.w,
                  height: 72.05.h,
                  child: firstSign(context),
                ),
                Container(
                  height: 17.89.h,
                  width: 100.w,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(forgetBg),
                    fit: BoxFit.fill,
                  )),
                  child: Row(
                    children: [
                      Container(
                          width: 6.38.w,
                          height: 6.38.w,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 7.91.w),
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
                        width: 2.08.h,
                      ),
                      Container(
                        width: 65.w,
                        child: text("My Profile",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.49.h,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 14.66.h,
                          width: 14.66.h,
                          child: LOGO == ''
                              ? Image(
                                  image: AssetImage(editProfile),
                                  fit: BoxFit.cover,
                                  height: 14.66.h,
                                  width: 14.66.h,
                                )
                              : Image(
                                  image: NetworkImage(LOGO),
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                     /* Container(
                        height: 4.39.h,
                        width: 4.39.h,
                        margin: EdgeInsets.only(right: 5.w, bottom: 1.h),
                        decoration: boxDecoration(
                            radius: 100, bgColor: Color(0xffF4B71E)),
                        child: Center(
                          child: Image.asset(
                            edit,
                            height: 2.26.h,
                            width: 2.26.h,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
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
          height: 9.92.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "User Name",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                name.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "Email",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                email.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "Mobile Number",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                mobile.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "Address",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                address.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "Store Name",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                storename.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                "Store Url",
                textColor: Color(0xff8A8787),
                fontSize: 10.sp,
                fontFamily: fontRegular,
              ),
              text(
                storeurl.toString(),
                textColor: Color(0xff202442),
                fontSize: 10.sp,
                fontFamily: fontBold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Center(
          child: Container(
            child: InkWell(
              onTap: () async {
                setState(() {
                  enabled = true;
                  selected = true;
                });
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {
                  enabled = false;
                });
                Navigator.push(
                    context,
                    PageTransition(
                      child: EditProfileScreen(),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                    ));
              },
              child: ScaleAnimatedWidget.tween(
                enabled: enabled,
                duration: Duration(milliseconds: 200),
                scaleDisabled: 1.0,
                scaleEnabled: 0.9,
                child: Container(
                  width: 69.99.w,
                  height: 6.46.h,
                  decoration: boxDecoration(
                      radius: 15.0, bgColor: AppColor().colorPrimaryDark()),
                  child: Center(
                    child: text(
                      "Update Profile",
                      textColor: Color(0xffffffff),
                      fontSize: 14.sp,
                      fontFamily: fontRegular,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.46.h,
        ),
      ],
    );
  }
}
