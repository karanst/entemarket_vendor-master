import 'package:animated_widgets/animated_widgets.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/AppBtn.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/NewScreen/bottom_bar.dart';
import 'package:ziberto_vendor/NewScreen/forget_screen.dart';
import 'package:ziberto_vendor/NewScreen/home_screen.dart';
import 'package:ziberto_vendor/NewScreen/signup_screen.dart';
import 'package:ziberto_vendor/Screen/Home.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool selected = false, enabled = false, edit = false;
  String? password,
      mobile,
      username,
      email,
      id,
      balance,
      image,
      address,
      city,
      area,
      pincode,
      fcm_id,
      srorename,
      storeurl,
      storeDesc,
      accNo,
      accname,
      bankCode,
      bankName,
      latitutute,
      longitude,
      taxname,
      tax_number,
      pan_number,
      status,
      storeLogo;
  bool _isNetworkAvail = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {
      phoneController.text = "9292929292";
      passController.text = "12345678";
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
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.1),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg2(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 22.65.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(loginBg),
                    fit: BoxFit.fill,
                  )),
                  child: Center(
                    child: text(
                      "Log In",
                      textColor: Color(0xffffffff),
                      fontSize: 22.sp,
                      fontFamily: fontMedium,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(top: 16.h),
                  width: 83.33.w,
                  height:47.96.h,
                  decoration:
                      boxDecoration(radius: 50.0, bgColor: Color(0xffffffff),showShadow: true),
                  child: firstSign(context),
                ),
                Container(
                  margin: EdgeInsets.only(top:80.h,bottom: 8.h),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        edit = true;
                      });
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {
                        edit = false;
                      });
                      Navigator.push(
                          context,
                          PageTransition(
                            child: SignUpScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          ));
                    },
                    child: ScaleAnimatedWidget.tween(
                      enabled: edit,
                      duration: Duration(milliseconds: 200),
                      scaleDisabled: 1.0,
                      scaleEnabled: 0.8,
                      child:  RichText(
                        text: new TextSpan(
                          text: "Don't Have An Account? ",
                          style: TextStyle(
                            color: Color(0xff171717),
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                              text: 'SignUp',
                              style: TextStyle(
                                color: AppColor().colorPrimary(),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ],
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
  Widget firstSign(BuildContext context){
    return _isNetworkAvail
        ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          SizedBox(
            height: 6.05.h,
          ),
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 69.99.w,
                    height: 6.46.h,
                    child: TextFormField(
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      style:TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      onSaved: (String? value) {
                        mobile = value;
                      },
                      inputFormatters: [],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(),
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),
                        fillColor: AppColor().colorEdit() ,
                        enabled: true,
                        filled: true,
                        prefixIcon:  Container(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            phone,
                            width: 1.04.w,
                            height:  1.04.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        suffixIcon: phoneController.text.length == 10
                            ? Container(
                            width: 1.04.w,
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:1.55.h,
                  ),
                  Container(
                    width: 69.99.w,
                    height: 6.46.h,
                    child: TextFormField(
                      cursorColor: Colors.red,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passController,
                      style:TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      onSaved: (String? value) {
                        password = value;
                      },
                      inputFormatters: [],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(),
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),
                        fillColor: AppColor().colorEdit() ,
                        enabled: true,
                        filled: true,
                        prefixIcon:  Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            lock,
                            width: 2.04.w,
                            height:  2.04.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                        suffixIcon: passController.text.length > 7
                            ? Container(
                            width: 1.04.w,
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:3.55.h,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                            child: ForgetScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          ));
                    },
                    child: Container(
                      width: 69.99.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          text(
                            "Forgot Password ?",
                            textColor: AppColor().colorTextThird(),
                            fontSize: 10.sp,
                            fontFamily: fontMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(
            height:4.75.h,
          ),
          Center(
            child:ScaleAnimatedWidget.tween(
                enabled: enabled,
                duration: Duration(milliseconds: 200),
                scaleDisabled: 1.0,
                scaleEnabled: 0.8,
                child: NewButton(
                  selected: edit,
                  width: 69.99.w,
                  textContent: "Log In",
                  onPressed: ()async{
                    setState(() {
                      enabled = true;
                    });
                    await Future.delayed(Duration(milliseconds: 200));
                    setState(() {
                      enabled = false;
                    });
                    if(validateMob(phoneController.text,context )!=null){
                      setSnackbar(validateMob(phoneController.text, context).toString(), context);
                      return;
                    }
                    if(validatePass(passController.text, context)!=null){
                      setSnackbar(validatePass(passController.text,context).toString(), context);
                      return;
                    }
                    setState(() {
                      edit = true;
                    });
                    checkNetwork();

                  },
                ),
            ),
          ),
          SizedBox(
            height:6.53.h,
          ),
      ],
    ):noInternet(context);
  }
  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: kToolbarHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            NewButton(
              selected: edit,
              textContent: getTranslated(context, 'TRY_AGAIN_INT_LBL').toString(),
              onPressed: (){
                Future.delayed(Duration(seconds: 2)).then(
                      (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget),
                      );
                    } else {

                      setState(
                            () {},
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getLoginUser();
    } else {
      setState(() {
        edit = false;
      });
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
  Future<void> getLoginUser() async {
    var data = {
      Mobile: phoneController.text,
      Password: passController.text,
    };

    apiBaseHelper.postAPICall(getUserLoginApi, data).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          setState(() {
            edit = false;
          });
          setSnackbar(msg!,context);
          var data = getdata["data"][0];
          id = data[Id];
          username = data[Username];
          email = data[Email];
          mobile = data[Mobile];
          city = data[City];
          area = data[Area];
          address = data[Address];
          pincode = data[Pincode];
          image = data[IMage];
          balance = data["balance"];
          CUR_USERID = id!;
          CUR_USERNAME = username!;
          CUR_BALANCE = balance!;
          srorename = data[Storename] ?? "";
          storeurl = data[Storeurl] ?? "";
          storeDesc = data[storeDescription] ?? "";
          accNo = data[accountNumber] ?? "";
          accname = data[accountName] ?? "";
          bankCode = data[BankCOde] ?? "";
          bankName = data[bankNAme] ?? "";
          latitutute = data[Latitude] ?? "";
          longitude = data[Longitude] ?? "";
          taxname = data[taxName] ?? "";
          tax_number = data[taxNumber] ?? "";
          pan_number = data[panNumber] ?? "";
          status = data[STATUS] ?? "";
          storeLogo = data[StoreLogo] ?? "";

          saveUserDetail(
            id!,
            username!,
            email!,
            mobile!,
            address!,
            srorename!,
            storeurl!,
            storeDesc!,
            accNo!,
            accname!,
            bankCode ?? "",
            bankName ?? "",
            latitutute ?? "",
            longitude ?? "",
            taxname ?? "",
            tax_number!,
            pan_number!,
            status!,
            storeLogo!,
          );
          setPrefrenceBool(isLogin, true);
          Navigator.push(
              context,
              PageTransition(
                child: BottomBar(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        } else {
          setSnackbar(msg!,context);
          setState(() {
            edit = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          edit = false;
        });
        setSnackbar(error.toString(),context);
      },
    );
  }
}
