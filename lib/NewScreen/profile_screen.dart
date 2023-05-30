import 'dart:convert';

import 'package:animated_widgets/widgets/scale_animated.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Model/delete_account_model.dart';
import 'package:ziberto_vendor/NewScreen/add_media.dart';
import 'package:ziberto_vendor/NewScreen/bottom_bar.dart';
import 'package:ziberto_vendor/NewScreen/change_password_screen.dart';
import 'package:ziberto_vendor/NewScreen/edit_profile_screen.dart';
import 'package:ziberto_vendor/NewScreen/login_screen.dart';
import 'package:ziberto_vendor/NewScreen/main_customer_support.dart';
import 'package:ziberto_vendor/NewScreen/open_your_store.dart';
import 'package:ziberto_vendor/NewScreen/payment_screen.dart';
import 'package:ziberto_vendor/NewScreen/plan_screen.dart';
import 'package:ziberto_vendor/NewScreen/view_profile_screen.dart';
import 'package:ziberto_vendor/Screen/Authentication/Login.dart';
import 'package:ziberto_vendor/Screen/Customers.dart';
import 'package:ziberto_vendor/Screen/ProductList.dart';
import 'package:ziberto_vendor/Screen/TermFeed/Terms_Conditions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool selected = false, enabled = false, edit1 = false;
  String address="",lat="",lon="",name = "",contact = "",email = "",image = "", userId = "";
  getSaveDetail() async {
    print("we are here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString(Address) ?? '';
      lat = prefs.getString(Latitude) ?? '';
      lat =  prefs.getString(Latitude) ?? '';
      lon =  prefs.getString(Longitude) ?? '';
      name =  prefs.getString(Username) ?? '';
      contact =  prefs.getString(Mobile) ?? '';
      email =  prefs.getString(Email) ?? '';
      image =  prefs.getString(Storeurl) ?? '';
      userId = prefs.getString(UserId) ?? '';
      print(image);
    });
  }

  Future<DeleteAccountModel?> deleteAccount() async {
    CUR_USERID = await getPrefrence(Id);
    var header = headers;
    var request = http.MultipartRequest('POST', Uri.parse('https://entemarket.com/seller/app/v1/api/delete_sellers'));
    request.headers.addAll(header);
    request.fields.addAll({
      'id': CUR_USERID.toString()
    });
    print("this is account deletion request ${request.fields.toString()}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: LoginScreen(),
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 500),
          ),(Route<dynamic> route) => false);

      var data  = DeleteAccountModel.fromJson(json.decode(str));
      setSnackbar(data.message.toString(), context);
      return DeleteAccountModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  deleteAccountDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: Text(
                    "Delete Your Account",
                    // style: Theme.of(this.context)
                    //     .textTheme
                    //     .subtitle1!
                    //     .copyWith(color: Theme.of(context).colorScheme.),
                  ),
                  actions: <Widget>[
                    TextButton(
                        child: Text(
                          "No",
                          // style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                          //     color: Theme.of(context).colorScheme.lightBlack,
                          //     fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: Text(
                          "Yes",
                          // style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                          //     color: Theme.of(context).colorScheme.fontColor,
                          //     fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          deleteAccount();
                          // SettingProvider settingProvider =
                          // Provider.of<SettingProvider>(context, listen: false);
                          // settingProvider.clearUserSession(context);
                          // //favList.clear();
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     '/home', (Route<dynamic> route) => false);
                        })
                  ],
                );
              });
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSaveDetail();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BottomBar()));
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
                              "My Account",
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            child: ViewProfileScreen(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                          ));
                    },
                    child: Container(
                        height: 11.40.h,
                        width: 82.91.w,
                        margin: EdgeInsets.only(
                            left: 8.33.w,
                            right: 8.33.w,
                            bottom: 1.87.h,
                            top: 1.87.h),
                        child: Row(
                          children: [
                            Container(
                              height: 9.76.h,
                              width: 9.76.h,
                              child: LOGO == ''?Image(
                                image: AssetImage(picture),
                                fit: BoxFit.fill,
                              ):Image(
                                image: NetworkImage(LOGO),
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 3.05.w,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: text(name,
                                        textColor: Color(0xff191919),
                                        fontSize: 14.0.sp,
                                        fontFamily: fontBold,
                                        overFlow: true),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Container(
                                    child: text(
                                      email,
                                      textColor: Color(0xff2a2a2a),
                                      fontSize: 10.sp,
                                      overFlow: true,
                                      fontFamily: fontRegular,
                                      maxLine: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 3.05.w,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: EditProfileScreen(),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 500),
                                    ));
                              },
                              child: Container(
                                height: 5.39.h,
                                width: 5.39.h,
                                decoration: boxDecoration(
                                    radius: 100,
                                    bgColor: Color(0xffF4B71E)),
                                child: Center(
                                  child: Image.asset(
                                    edit,
                                    height: 2.26.h,
                                    width: 2.26.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  tabItem(context, 8, payment, "Membership Plan"),
                  tabItem(context, 9, "images/gallery.png", "Add Media"),
                  tabItem(context, 5, payment, "All Products"),
                  tabItem(context, 6, "images/service_profile.png", "All Customers"),

                  tabItem(context, 1, payment, "Earning Management"),
                  tabItem(context, 2, changePass, "Change Password"),
                  tabItem(context, 10, delete, "Delete Account"),
                  tabItem(context, 3, serviceIcon, "Store open and close timing"),
                  tabItem(context, 4, support, "Customer Support"),
                  tabItem(context, 7, "images/service_history.png", "Term and Conditions"),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          edit1 = true;
                        });
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {
                          edit1 = false;
                        });
                        logOutDailog();

                      },
                      child: ScaleAnimatedWidget.tween(
                        enabled: edit1,
                        duration: Duration(milliseconds: 200),
                        scaleDisabled: 1.0,
                        scaleEnabled: 0.9,
                        child: Container(
                          height: 7.09.h,
                          width: 42.63.w,
                          decoration: boxDecoration(
                              radius: 15.0,
                              bgColor: AppColor().colorPrimaryDark()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Image.asset(
                                  logout,
                                  height: 3.82.h,
                                  width: 3.82.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              text(
                                "Log Out",
                                textColor: Color(0xffffffff),
                                fontSize: 10.sp,
                                fontFamily: fontRegular,
                              ),
                            ],
                          ),
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
        ),
      ),
    );
  }
  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar()));
    return Future.value(true);
  }
  Widget tabItem(BuildContext context, var pos, var icon, String title) {
    return InkWell(
      onTap: () {
        if (pos == 1) {
          Navigator.push(
              context,
              PageTransition(
                child: PaymentScreen(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }

        if (pos == 2) {
          Navigator.push(
              context,
              PageTransition(
                child: ChangeScreen(mobile: "mobile",),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 3) {
          Navigator.push(
              context,
              PageTransition(
                child: OpenYourStore(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 4) {
          Navigator.push(
              context,
              PageTransition(
                child: MainCustomerSupport(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 5) {
          Navigator.push(
              context,
              PageTransition(
                child: ProductList(  flag: '',),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 6) {
          Navigator.push(
              context,
              PageTransition(
                child: Customers(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 7) {
          Navigator.push(
              context,
              PageTransition(
                child: Terms_And_Condition(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 8) {
          Navigator.push(
              context,
              PageTransition(
                child: PlanScreen(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        if (pos == 9) {
          Navigator.push(
              context,
              PageTransition(
                child: AddMedia(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 500),
              ));
        }
        else if (pos == 10){
          deleteAccountDailog();
        }
      },
      child: Container(
          height: 11.25.h,
          width: 86.91.w,
          decoration: boxDecoration(
            showShadow: true,
            radius: 20.0,
            bgColor: AppColor().colorBg1(),
          ),
          margin: EdgeInsets.only(left: 6.33.w, right: 6.33.w, bottom: 1.87.h),
          padding: EdgeInsets.only(left: 6.05.w, right: 3.05.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 3.82.h,
                width: 3.82.h,
                child: Image(
                  image: AssetImage(icon),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: text(title,
                    textColor: Color(0xff191919),
                    fontSize: 10.5.sp,
                    fontFamily: fontBold,
                    overFlow: true),
              ),
              SizedBox(
                width: 1.05.w,
              ),
              Container(
                height: 6.32.h,
                width: 6.32.h,
                decoration: boxDecoration(
                    radius: 100,
                    bgColor: AppColor().colorBottom().withOpacity(0.15)),
                child: Center(
                  child: Image(
                    image: AssetImage(arrowForward),
                    color:AppColor().colorBottom() ,
                    fit: BoxFit.fill,
                    height: 1.87.h,
                    width: 1.80.w,
                  ),
                ),
              ),
            ],
          )),
    );
  }
  logOutDailog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              content: Text(
                getTranslated(context, "LOGOUTTXT")!,
                style: Theme.of(this.context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: fontColor),
              ),
              actions: <Widget>[
                new TextButton(
                    child: Text(
                      getTranslated(context, "LOGOUTNO")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                          color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                new TextButton(
                  child: Text(
                    getTranslated(context, "LOGOUTYES")!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: fontColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    clearUserSession();
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: LoginScreen(),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 500),
                        ),(Route<dynamic> route) => false);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
