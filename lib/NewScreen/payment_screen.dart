import 'package:animated_widgets/animated_widgets.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Helper/myappbar.dart';
import 'package:ziberto_vendor/Model/getWithdrawelRequest/getWithdrawelmodel.dart';

bool _isLoading = true;
bool isLoadingmore = true;
int offset = 0;
int total = 0;
List<GetWithdrawelReq> tranList = [];
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool selected = false, enabled = false, edit = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isNetworkAvail = true;
  String? amount, msg;
  ScrollController controller = new ScrollController();
  TextEditingController? amtC, bankDetailC;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GetWithdrawelReq> tempList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getSaveDetail();
    getWithdrawalRequest();
    getSallerBalance();
    controller.addListener(_scrollListener);

    amtC = new TextEditingController();
    bankDetailC = new TextEditingController();
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          if (offset < total) getWithdrawalRequest();
        });
      }
    }
  }

  getSallerBalance() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      CUR_USERID = await getPrefrence(Id);

      var parameter = {Id: CUR_USERID};
      apiBaseHelper.postAPICall(getSellerDetails, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            var data = getdata["data"][0];
            CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
          }
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
          setState(() {
            _isLoading = false;
          });
        },
      );
    } else {
      if (mounted)
        setState(
              () {
            _isNetworkAvail = false;
            _isLoading = false;
          },
        );
    }
    return null;
  }

  Future<Null> getWithdrawalRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var parameter = {UserId: CUR_USERID};
      apiBaseHelper.postAPICall(getWithDrawalRequestApi, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            total = int.parse(
              getdata["total"],
            );
            if ((offset) < total) {
              tempList.clear();
              var data = getdata["data"];

              tempList = (data as List)
                  .map((data) => new GetWithdrawelReq.fromReqJson(data))
                  .toList();

              tranList.addAll(tempList);

              offset = offset + perPage;
            }
            await getSallerBalance();
          }
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
          setState(
                () {
              _isLoading = false;
              isLoadingmore = false;
            },
          );
        },
      );
    } else
      setState(() {
        _isNetworkAvail = false;
      });
    return null;
  }
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
                MyappBarView(
                  mytitle: "Payment",
                ),
                // Container(
                //   height: 9.92.h,
                //   width: 100.w,
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage(profileBg),
                //         fit: BoxFit.fill,
                //       )),
                //   child: Center(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Container(
                //             width: 6.38.w,
                //             height: 6.38.w,
                //             alignment: Alignment.centerLeft,
                //             margin: EdgeInsets.only(left: 7.91.w),
                //             child: InkWell(
                //                 onTap: () {
                //                   Navigator.pop(context);
                //                 },
                //                 child: Image.asset(
                //                   back,
                //                   height: 4.0.h,
                //                   width: 8.w,
                //                 ))),
                //         SizedBox(
                //           width: 2.08.h,
                //         ),Container(
                //           width: 65.w,
                //           child: text(
                //             "Payment",
                //             textColor: Color(0xffffffff),
                //             fontSize: 14.sp,
                //             fontFamily: fontMedium,
                //             isCentered: true,
                //           ),
                //         ),

                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  padding:
                      EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                  height: 22.26.h,
                  decoration: boxDecoration(
                    showShadow: true,
                    radius: 20.0,
                    bgColor: AppColor().colorBg1(),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        filter,
                        height: 2.26.h,
                        width: 2.26.h,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                paymentIcon,
                                height: 8.75.h,
                                width: 21.94.w,
                              ),
                            ),
                            SizedBox(
                              height: 1.12.h,
                            ),
                            text(
                              "Your Total Earning",
                              textColor: Color(0xff707070),
                              fontSize: 14.sp,
                              fontFamily: fontBold,
                            ),
                            SizedBox(
                              height: 1.02.h,
                            ),
                            text(
                              "₹"+CUR_BALANCE,
                              textColor: Color(0xff000000),
                              fontSize: 14.sp,
                              fontFamily: fontBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  width: 100.w,
                  child: text(
                    "Request For Money",
                    textColor: Color(0xff202442),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  padding: EdgeInsets.only(left: 2.91.w, right: 2.91.w),
                  height: 8.21.h,
                  decoration: boxDecoration(
                    showShadow: true,
                    radius: 20.0,
                    bgColor: AppColor().colorBg1(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 26.52.w,
                        height: 5.23.h,
                        child: TextFormField(
                          cursorColor: Colors.red,
                          keyboardType: TextInputType.number,
                           controller: amountController,
                          style: TextStyle(
                            color: AppColor().colorTextFour(),
                            fontSize: 10.sp,
                          ),
                          inputFormatters: [],
                          decoration: InputDecoration(
                            labelText: '',
                            labelStyle: TextStyle(
                              color: AppColor().colorTextFour(),
                              fontSize: 10.sp,
                            ),
                            fillColor: AppColor().colorEdit(),
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
                      InkWell(
                        onTap: () async {
                          setState(() {
                            enabled = true;
                          });
                          await Future.delayed(Duration(milliseconds: 200));
                          setState(() {
                            enabled = false;
                          });
                          sendRequest();
                          setState(() {
                            offset = 0;
                            total = 0;
                            tranList.clear();
                          });

                          //    Navigator.push(context, PageTransition(child: LoginScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
                        },
                        child: ScaleAnimatedWidget.tween(
                          enabled: enabled,
                          duration: Duration(milliseconds: 200),
                          scaleDisabled: 1.0,
                          scaleEnabled: 0.9,
                          child: Container(
                            width: 26.52.w,
                            height: 5.23.h,
                            decoration: boxDecoration(
                                radius: 15.0,
                                bgColor: AppColor().colorPrimaryDark()),
                            child: Center(
                              child: text(
                                "Request",
                                textColor: Color(0xffffffff),
                                fontSize: 10.sp,
                                fontFamily: fontRegular,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                  width: 100.w,
                  child: text(
                    "Payment History",
                    textColor: Color(0xff202442),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                ),
                SizedBox(
                  height: 1.52.h,
                ),
                Container(
                  margin: EdgeInsets.only(top: 1.87.h),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (offset < total)
                          ? tranList.length + 1
                          : tranList.length,
                      itemBuilder: (context, index) {
                        return  (index == tranList.length &&
                            isLoadingmore)
                            ? Center(
                            child: CircularProgressIndicator())
                            : Container(
                            height: 11.25.h,
                            width: 82.91.w,
                            decoration: boxDecoration(
                              showShadow: true,
                              radius: 20.0,
                              bgColor: AppColor().colorBg1(),
                            ),
                            margin: EdgeInsets.only(
                                left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                            padding:
                                EdgeInsets.only(left: 3.05.w, right: 3.05.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 7.81.h,
                                  width: 7.81.h,
                                  child: Image(
                                    image: AssetImage(package),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 1.6.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: text("Invoice ID : #${tranList[index].id!}",
                                            textColor: Color(0xff191919),
                                            fontSize: 10.5.sp,
                                            fontFamily: fontBold,
                                            overFlow: true),
                                      ),
                                      SizedBox(
                                        height: 1.9.h,
                                      ),
                                      Container(
                                        child: text("Payment Mode: ${tranList[index].paymentType!.toString()}",
                                            textColor: Color(0xff191919),
                                            fontSize: 7.5.sp,
                                            fontFamily: fontBold,
                                            overFlow: true),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            text(
                                              "Amount Paid : ",
                                              textColor: Color(0xff000000),
                                              fontSize: 7.5.sp,
                                              fontFamily: fontBold,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            text(
                                              "₹${tranList[index].amountRequested!}",
                                              textColor: Color(0xffF4B71E),
                                              fontSize: 7.5.sp,
                                              fontFamily: fontBold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 1.05.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 1.9.h),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              tranList[index].status == "success" ||
                                                  tranList[index].status == ACCEPTEd ? greenIcon : redIcon),
                                          fit: BoxFit.fill,
                                          height: 3.20.h,
                                          width: 3.20.h,
                                        ),
                                        text(
                                          tranList[index].status == "success" ||
                                              tranList[index].status == ACCEPTEd ? "Received" : "Pending",
                                          textColor: tranList[index].status == "success" ||
                                              tranList[index].status == ACCEPTEd ?
                                               Color(0xff79A11D):Colors.red,
                                          fontSize: 7.5.sp,
                                          fontFamily: fontRegular,
                                        ),
                                        SizedBox(
                                          height: 0.7.h,
                                        ),
                                        text(
                                          "${tranList[index].dateCreated!}",
                                          textColor: Color(0xff000000),
                                          fontSize: 7.5.sp,
                                          fontFamily: fontSemibold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }),
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
  String address="",lat="",lon="";
  getSaveDetail() async {
    print("we are here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    address = await getPrefrence(Address) ?? '';
    lat = await getPrefrence(Latitude) ?? '';
    lon = await getPrefrence(Longitude) ?? '';
  }
  Future<Null> sendRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      //    try {
      var parameter = {
        UserId: CUR_USERID,
        Amount: amountController.text.toString(),
        PaymentAddress: address,
      };

      apiBaseHelper.postAPICall(sendWithDrawalRequestApi, parameter).then(
            (getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            setSnackbar(msg!,context);
            print("we are here");
            setState(
                  () {
                    amountController.text="";
                _isLoading = true;
              },
            );
            tranList.clear();
            getWithdrawalRequest();
          } else {
            setSnackbar(msg!,context);
          }
        },
      );
    } else {
      if (mounted)
        setState(
              () {
            _isNetworkAvail = false;
            _isLoading = false;
          },
        );
    }

    return null;
  }
}
