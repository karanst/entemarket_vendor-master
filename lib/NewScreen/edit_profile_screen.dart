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
import 'package:ziberto_vendor/Screen/Home.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController urlController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController storeController = new TextEditingController();
  TextEditingController addController = new TextEditingController();
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
      phoneController.text = prefs.getString(Mobile).toString();
      nameController.text = prefs.getString(Username).toString();
      emailController.text = prefs.getString(Email).toString();
      addController.text = prefs.getString(Address).toString();
      image = prefs.getString(IMage);
      CUR_USERID = prefs.getString(Id);
      mobile = prefs.getString(Mobile);
      storeController.text = prefs.getString(Storename).toString();
      urlController.text = prefs.getString(Storeurl).toString();
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
      backgroundColor:AppColor().colorBg1(),
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
                  width: 83.33.w,
                  height:  62.96.h,
                  decoration: BoxDecoration( color: Color(0xffffffff),
                      boxShadow:  [BoxShadow(color: AppColor().colorView().withOpacity(0.1), blurRadius: 4, spreadRadius: 1)],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular( 50.0),
                        bottomRight: Radius.circular( 50.0)),),
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
                  child:  Row(
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
                        child: text(
                            "Edit Profile",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.49.h,
                  child:  Stack(
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
                      /*Container(
                        height: 4.39.h,
                        width: 4.39.h,
                        margin: EdgeInsets.only(right: 5.w,bottom: 1.h),
                        decoration: boxDecoration(radius: 100,bgColor: Color(0xffF4B71E)),
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 87.h,bottom: 8.h),
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
                       checkNetwork();
                        //  Navigator.push(context, PageTransition(child: EditProfileScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
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
                              "Save",
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
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
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

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.text,
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
                      labelText: 'Address',
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
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    keyboardType: TextInputType.name,
                    controller: storeController,
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
                      labelText: 'Store Name',
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
                          person,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 69.99.w,
                  height: 6.46.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
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
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          email1,
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.46.h,
        ),
      ],
    );
  }
  Future<void> setUpdateUser() async {
    var parameter = {
      Id: CUR_USERID,
      Name: name ?? "",
      Mobile: mobile ?? "",
      Email: email ?? "",
      Address: address ?? "",
      Storename: storename ?? "",
      Storeurl: storeurl ?? "",
      storeDescription: storeDesc ?? "",
      accountNumber: accNo ?? "",
      accountName: accname ?? "",
      bankCode: bankcode ?? "",
      bankName: bankname ?? "",
      Latitude: latitutute ?? "",
      Longitude: longitude ?? "",
      taxName: taxname ?? "",
      taxNumber: taxnumber ?? "",
      panNumber: pannumber ?? "",
      STATUS: status ?? "1",
    };

    apiBaseHelper.postAPICall(updateUserApi, parameter).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {

          setSnackbar(msg!,context);
        } else {

          setSnackbar(msg!,context);
          setState(() {});
        }
      },
      onError: (error) {
        setSnackbar(error.toString(),context);
      },
    );
  }
  bool _isNetworkAvail = true;
  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {

      setUpdateUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then(
            (_) async {
          setState(
                () {
              _isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  Future<void> changePassWord() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var parameter = {
        Id: CUR_USERID,
        Name: name ?? "",
        Mobile: mobile ?? "",
        Email: email ?? "",
        Address: address ?? "",
        Storename: storename ?? "",
        Storeurl: storeurl ?? "",
        storeDescription: storeDesc ?? "",
        accountNumber: accNo ?? "",
        accountName: accname ?? "",
        bankCode: bankcode ?? "",
        bankName: bankname ?? "",
        Latitude: latitutute ?? "",
        Longitude: longitude ?? "",
        taxName: taxname ?? "",
        taxNumber: taxnumber ?? "",
        panNumber: pannumber ?? "",
        STATUS: status ?? "1",
        OLDPASS: curPass,
        NEWPASS: newPass,
      };
      apiBaseHelper.postAPICall(updateUserApi, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            Navigator.pop(context);
            setSnackbar(msg!,context);
          } else {
            Navigator.pop(context);
            setSnackbar(msg!,context);
          }
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
        },
      );
    } else {

    }
  }
}
