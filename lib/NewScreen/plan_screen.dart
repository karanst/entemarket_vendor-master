import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Razorpay.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Model/plan_model.dart';
import 'package:ziberto_vendor/NewScreen/bottom_bar.dart';
import 'package:http/http.dart' as http;

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool isSwitched = false;
  List<PlanModel> planList = [];
  List<PlanModel> currentList = [];
  String? start, end;
  bool _isNetworkAvail = true, loading = true;
  Future<Null> getPlan() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      CUR_USERID = await getPrefrence(Id);
      setState(() {
        planList.clear();
      });
      var parameter = {Id: CUR_USERID};
      var response = await http
          .get(Uri.parse("https://entemarket.com/app/v1/api/plan_all_info"));

      Map data = jsonDecode(response.body);
      bool error = data["error"];
      String? msg = data["message"];
      setState(() {
        loading = false;
      });
      if (!error) {
        for (var v in data["date"]) {
          setState(() {
            planList.add(new PlanModel(
                v['id'],
                v['name'],
                v['plan_id'],
                v['seller_id'],
                "https://entemarket.com/"+v['image'],
                v['price'],
                v['product_upload'],
                v['digital_product_upload'],
                v['package_duration'],
                v['status'],
                v['pos']));
          });
        }
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          loading = false;
        });
    }

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlan();
    getCurrent();
  }

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
                            "Plans",
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
                  height: 80.h,
                  margin: EdgeInsets.only(top: 1.87.h),
                  alignment: Alignment.center,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 70.h,
                      viewportFraction: 0.8,
                      enableInfiniteScroll: false,
                    ),
                    items: planList.map((e) {
                      return Container(
                        width: 80.w,
                        decoration: boxDecoration(
                          radius: 10.0,
                          showShadow: true,
                        ),
                        margin: EdgeInsets.only(bottom: 5.w, right: 5.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: new LinearGradient(
                                      colors: [
                                        Color(0xff8B7C3E),
                                        Color(0xffFDF188),
                                        Color(0xffA68E46),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  child: text(getString(e.name),
                                      fontFamily: fontBold,
                                      fontSize: 14.sp,
                                      textColor: Color(0xffA26F15))),
                              CachedNetworkImage(
                                imageUrl: e.image,
                                height: 20.w,
                                width: 20.w,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                              ),
                              Divider(),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      text("Package Duration",
                                          fontSize: 14.sp,
                                          fontFamily: fontRegular,
                                          textColor: Color(0xff000000)),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      text("${e.package_duration} Months",
                                          fontSize: 10.sp,
                                          fontFamily: fontMedium,
                                          textColor: Color(0xff828282)),
                                    ],
                                  )),
                              Divider(),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      text("Product Upload",
                                          fontSize: 14.sp,
                                          fontFamily: fontRegular,
                                          textColor: Color(0xff000000)),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      text("${e.product_upload}",
                                          fontSize: 10.sp,
                                          fontFamily: fontMedium,
                                          textColor: Color(0xff828282)),
                                    ],
                                  )),
                              Divider(),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      text("Digital Product Upload",
                                          fontSize: 14.sp,
                                          fontFamily: fontRegular,
                                          textColor: Color(0xff000000)),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      text("${e.digital_product_upload}",
                                          fontSize: 10.sp,
                                          fontFamily: fontMedium,
                                          textColor: Color(0xff828282)),
                                    ],
                                  )),
                              Divider(),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      text("Point Of Sale",
                                          fontSize: 14.sp,
                                          fontFamily: fontRegular,
                                          textColor: Color(0xff000000)),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      text(e.pos=="0"?"Available":"Not Available",
                                          fontSize: 10.sp,
                                          fontFamily: fontMedium,
                                          textColor: Color(0xff828282)),
                                    ],
                                  )),
                              InkWell(
                                onTap: (){
                                  if(currentList.length>0&&currentList[currentList.length-1].status=="0"){
                                    setSnackbar("Already Activated", context);
                                    return;
                                  }
                                  RazorPayHelper razorHelper = new RazorPayHelper(
                                      e.price,
                                      context,
                                      (result) {
                                        if(result!="error"){
                                          addPlan(e.id);
                                        }
                                  });
                                  razorHelper.init();
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: new LinearGradient(
                                        colors: [
                                          Color(0xff8B7C3E),
                                          Color(0xffFDF188),
                                          Color(0xffA68E46),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 2.h),
                                    child: text(currentList.length>0&&currentList[currentList.length-1].plan_id==e.id?"Activated":"BUY",
                                        fontFamily: fontBold,
                                        fontSize: 14.sp,
                                        textColor: Color(0xffA26F15))),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<Null> addPlan(id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      CUR_USERID = await getPrefrence(Id);
      var parameter = {"seller_id": CUR_USERID,"plan_id":id};
      apiBaseHelper.postAPICall(Uri.parse("https://entemarket.com/app/v1/api/payment_success"), parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          print(getdata);
          if (!error) {
            getCurrent();
            setSnackbar(msg!, context);
          }
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
        },
      );
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;

        });
    }

    return null;
  }
  Future<Null> getCurrent() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      setState(() {
        currentList.clear();
      });
      CUR_USERID = await getPrefrence(Id);
      var parameter = {"seller_id": CUR_USERID};
      apiBaseHelper.postAPICall(Uri.parse("https://entemarket.com/app/v1/api/get_plan_membership"), parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          print(getdata);
          if (!error) {
            for (var v in getdata["res"]) {
              setState(() {
                currentList.add(new PlanModel(
                    v['id'],
                    v['name'],
                    v['plan_id'],
                    v['seller_id'],
                    "https://entemarket.com/"+v['image'],
                    v['price'],
                    v['product_upload'],
                    v['digital_product_upload'],
                    v['package_duration'],
                    v['status'],
                    v['pos']));
              });
            }
          }
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
        },
      );
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;

        });
    }

    return null;
  }
}
