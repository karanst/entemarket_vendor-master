
import 'package:flutter/material.dart';

import 'package:animated_widgets/widgets/scale_animated.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/images.dart';
class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({Key? key}) : super(key: key);

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  bool selected = false, enabled = false, edit = false;
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
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
            child: Column(
              children: [
                Container(
                  height: 9.92.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(profileBg),
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
                            "Service Profile",
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
                  height: 5.02.h,
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                    child: secondSign(context)),
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
                            radius: 15.0,
                            bgColor: AppColor().colorPrimaryDark()),
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
                SizedBox(
                  height: 4.02.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<String> day = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  List<String> time = [
    "09:30AM - 11:00AM",
    "11:00AM - 12:30PM",
    "01:30PM - 03:00PM",
    "03:00PM - 04:30PM",
    "04:30PM - 06:00PM"
  ];
  int dayIndex=0;
  int timeIndex=0;
  Widget secondSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          height: 7.46.h,
          decoration: boxDecoration(
            radius: 10.0,
            bgColor: AppColor().colorEdit(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.5.w),
                    child: Image.asset(
                      service,
                      width: 6.04.w,
                      height: 5.04.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  text(
                    "Service type",
                    textColor: AppColor().colorTextFour(),
                    fontSize: 10.sp,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(3.5.w),
                child: Image.asset(
                  down,
                  width: 6.04.w,
                  height: 6.04.w,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.5.h,
        ),
        Container(
          height: 7.46.h,
          decoration: boxDecoration(
            radius: 10.0,
            bgColor: AppColor().colorEdit(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.5.w),
                    child: Image.asset(
                      special,
                      width: 6.04.w,
                      height: 5.04.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  text(
                    "Service type",
                    textColor: AppColor().colorTextFour(),
                    fontSize: 10.sp,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(3.5.w),
                child: Image.asset(
                  down,
                  width: 6.04.w,
                  height: 6.04.w,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 2.62.h,
        ),
        text(
          "Business Days & Time",
          textColor: Color(0xffFD531F),
          fontSize: 14.sp,
          fontFamily: fontBold,
        ),
        SizedBox(
          height: 2.96.h,
        ),
        Container(
          height: 5.07.h,
          child: ListView.builder(
              itemCount: day.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    setState(() {
                      enabled = true;
                      selected = true;
                      dayIndex=index;
                    });
                    await Future.delayed(Duration(milliseconds: 200));
                    setState(() {
                      enabled = false;
                    });
                    //  Navigator.push(context, PageTransition(child: SignUpScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
                  },
                  child: ScaleAnimatedWidget.tween(
                    enabled: enabled,
                    duration: Duration(milliseconds: 200),
                    scaleDisabled: 1.0,
                    scaleEnabled: 0.9,
                    child: Container(
                      width: 14.86.w,
                      height: 6.46.h,
                      margin: EdgeInsets.only(right: 3.w),
                      decoration: boxDecoration(
                          radius: 15.0, bgColor: dayIndex==index?AppColor().colorPrimaryDark():AppColor().colorEdit()),
                      child: Center(
                        child: text(
                          day[index],
                          textColor: dayIndex==index?Color(0xffffffff):AppColor().colorTextFour(),
                          fontSize: 9.sp,
                          fontFamily: fontRegular,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 4.53.h,
        ),
        Container(
          height:  27.53.h,
          child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 2.8,
              mainAxisSpacing: 14.0,
              crossAxisSpacing: 2.0,
              children: time.map((e){
                int index=time.indexWhere((element) => element==e);
                return InkWell(
                  onTap: () async {
                    setState(() {
                      enabled = true;
                      selected = true;
                      timeIndex=index;
                    });
                    await Future.delayed(Duration(milliseconds: 200));
                    setState(() {
                      enabled = false;
                    });
                    //  Navigator.push(context, PageTransition(child: SignUpScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
                  },
                  child: ScaleAnimatedWidget.tween(
                    enabled: enabled,
                    duration: Duration(milliseconds: 200),
                    scaleDisabled: 1.0,
                    scaleEnabled: 0.9,
                    child: Container(
                      width: 34.86.w,
                      height: 6.46.h,
                      margin: EdgeInsets.only(right: 2.w),
                      decoration: boxDecoration(
                          radius: 15.0, bgColor: timeIndex==index?AppColor().colorPrimaryDark():AppColor().colorEdit()),
                      child: Center(
                        child: text(
                          e,
                          textColor: timeIndex==index?Color(0xffffffff):AppColor().colorTextFour(),
                          fontSize: 9.sp,
                          fontFamily: fontRegular,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()
          ),
        ),
      ],
    );
  }
}
