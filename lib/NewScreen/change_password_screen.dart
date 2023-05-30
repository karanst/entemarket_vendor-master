
import 'package:animated_widgets/animated_widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/NewScreen/login_screen.dart';

class ChangeScreen extends StatefulWidget {
    String? mobile = "mobile";
   ChangeScreen({Key? key,this.mobile}) : super(key: key);

  @override
  _ChangeScreenState createState() => _ChangeScreenState();
}

class _ChangeScreenState extends State<ChangeScreen> {
  TextEditingController oldPass = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  bool selected = false, enabled = false, edit = false;
  bool _isNetworkAvail = true;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
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
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
    return Scaffold(
      backgroundColor: AppColor().colorBg1(),
      body: _isNetworkAvail?SafeArea(
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
            child: Column(
              children: [
                Container(
                  height: 9.92.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(forgetBg),
                        fit: BoxFit.fill,
                      )),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            "Change Password",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.52.h,
                      ),
                      widget.mobile=="mobile"?Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: oldPass,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText: 'Enter Your Old Password',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ):SizedBox(),
                      SizedBox(
                        height: 2.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: passController,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText: 'Enter New Password',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,

                        child:text(
                          "Your New Password must be Different From Your Previous Passwords.",
                          textColor: Color(0xffFD531F),
                          fontSize: 10.sp,
                          fontFamily: fontSemibold,
                          maxLine: 2
                        ) ,
                      ),
                      SizedBox(
                        height: 1.52.h,
                      ),
                      Container(
                        width: 83.33.w,
                        height: 6.79.h,
                        decoration: boxDecoration(
                          showShadow: true,
                          radius: 20.0,
                          bgColor: AppColor().colorBg1(),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.text,
                          controller: cPassController,
                          obscureText: true,
                          // controller: emailController,
                          style:TextStyle(
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                            labelText: 'Confirm New Password',
                            prefixIcon:  Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: Image.asset(
                                lock,
                                width: 2.04.w,
                                height:  2.04.w,
                                color: Color(0xffF4B71E),
                                fit: BoxFit.fill,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorBg1() ,
                            enabled: true,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().colorBg1(), width: 5.0),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                    ),

                SizedBox(
                  height: 3.02.h,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        enabled = true;
                      });
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {
                        enabled = false;
                      });
                      Navigator.pop(context);
                      //    Navigator.push(context, PageTransition(child: LoginScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));

                    },
                    child: ScaleAnimatedWidget.tween(
                      enabled: enabled,
                      duration: Duration(milliseconds: 200),
                      scaleDisabled: 1.0,
                      scaleEnabled: 0.9,
                      child: NewButton(
                        selected: edit,
                        width: 69.98.w,
                        textContent: "Save",
                        onPressed: ()async{
                          setState(() {
                            enabled = true;
                          });
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            enabled = false;
                          });
                          if(validatePass(passController.text, context)!=null){
                            setSnackbar(validatePass(passController.text,context).toString(), context);
                            return;
                          }
                          if(passController.text != cPassController.text){
                            setSnackbar("Both Password Doesn't Match", context);
                            return;
                          }
                          if(widget.mobile!="mobile"){
                            setState(() {
                              edit = true;
                            });
                            checkNetwork();
                          }else{
                            if(validatePass(oldPass.text, context)!=null){
                              setSnackbar("Enter Old Password", context);
                              return;
                            }
                            changePassWord();
                          }


                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.02.h,
                ),
              ],
            ),
          ),
        ),
      ):noInternet(context),
    );
  }
  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getResetPass();
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
        OLDPASS: oldPass.text,
        NEWPASS: passController.text,
      };
      apiBaseHelper.postAPICall(updateUserApi, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          setState(() {
            edit = false;
          });
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
  Future<void> getResetPass() async {
    var data = {
      mobileno: widget.mobile,
      NEWPASS: passController.text,
    };
    apiBaseHelper.postAPICall(forgotPasswordApi, data).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];
        setState(() {
          edit = false;
        });
        if (!error) {
          setSnackbar(getTranslated(context, "PASS_SUCCESS_MSG")!,context);
          Future.delayed(
            Duration(seconds: 1),
          ).then(
                (_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
            },
          );
        } else {
          setSnackbar(msg!,context);
        }
      },
      onError: (error) {
        setSnackbar(error.toString(),context);
      },
    );
  }
}
