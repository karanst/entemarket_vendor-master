
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/NewScreen/bottom_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
    return Scaffold(
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
                            "Notification",
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
                Container(
                  margin: EdgeInsets.only(top: 1.87.h),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                            height: 11.40.h,
                            width: 82.91.w,
                            decoration: boxDecoration(
                              showShadow: true,
                              radius: 0.0,
                              bgColor: AppColor().colorBg1(),
                            ),
                            margin: EdgeInsets.only(
                                left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                            padding:
                                EdgeInsets.only(left: 3.05.w, right: 2.05.w),
                            child: Row(
                              children: [
                                Container(
                                  height: 6.32.h,
                                  width: 6.32.h,
                                  child: Image(
                                    image: AssetImage(notificationIcon),
                                    color: AppColor().colorPrimaryDark(),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.05.w,
                                ),
                                Container(
                                  width: 57.5.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: text("Order Update",
                                            textColor: Color(0xff191919),
                                            fontSize: 11.5.sp,
                                            fontFamily: fontBold,
                                            overFlow: true),
                                      ),
                                      SizedBox(
                                        height: 0.79.h,
                                      ),
                                      Container(
                                        child: text(
                                          "Your Order No. #741852 is 30% Grow Successfully. May Be Delivered on 23-6-2020",
                                          textColor: Color(0xff2a2a2a),
                                          fontSize: 7.sp,
                                          overFlow: true,
                                          fontFamily: fontRegular,
                                          maxLine: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
