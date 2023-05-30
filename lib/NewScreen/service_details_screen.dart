import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Helper/map.dart';
import 'package:ziberto_vendor/Model/OrdersModel/OrderItemsModel.dart';
import 'package:ziberto_vendor/Model/OrdersModel/OrderModel.dart';
import 'package:ziberto_vendor/Model/Person/PersonModel.dart';
import 'package:ziberto_vendor/NewScreen/bottom_bar.dart';
import 'package:ziberto_vendor/NewScreen/chat_page.dart';
import 'package:ziberto_vendor/Screen/Home.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ziberto_vendor/Screen/OrderDetail.dart';
List<PersonModel> delBoyList = [];
class ServiceScreenDetails extends StatefulWidget {
  final String? id;
    ServiceScreenDetails({Key? key,this.id}) : super(key: key);

  @override
  _ServiceScreenDetailsState createState() => _ServiceScreenDetailsState();
}

class _ServiceScreenDetailsState extends State<ServiceScreenDetails> {
  ScrollController controller = new ScrollController();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool _isNetworkAvail = true;
  bool show = true,show1 = true;
  String type="Delivery Boy",deliveryStatus = "Update Delivery Status";
  Order_Model? model;
  String? pDate, prDate, sDate, dDate, cDate, rDate;
  List<String> statusList = [
    PLACED,
    PROCESSED,
   /* SHIPED,
    DELIVERD,*/
    CANCLED,
    RETURNED,
  ];
  bool isLoading = true;

  List<Order_Model> tempList = [];
  bool? _isCancleable, _isReturnable;
  bool _isProgress = false;
  String? curStatus;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController? otpC;
  final List<DropdownMenuItem> items = [];
  List<PersonModel> searchList = [];
  // String? selectedValue;
  int? selectedDelBoy;
  final TextEditingController _controller = TextEditingController();
  late StateSetter delBoyState;
  bool fabIsVisible = true;

  bool selected = false, enabled = false, edit = false;
  String address="",lat="",lon="",name = "",contact = "",image = "";
  getSaveDetail() async {
    print("we are here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    address = await getPrefrence(Address) ?? '';
    lat = await getPrefrence(Latitude) ?? '';
    lon = await getPrefrence(Longitude) ?? '';
    name = await getPrefrence(Username) ?? '';
    contact = await getPrefrence(Mobile) ?? '';
  }

  @override
  void initState() {

    getDeliveryBoy();
    Future.delayed(Duration.zero, this.getOrderDetail);
    getSaveDetail();
    super.initState();

    controller = ScrollController();
    controller.addListener(
          () {
        setState(
              () {
            fabIsVisible = controller.position.userScrollDirection ==
                ScrollDirection.forward;
          },
        );
      },
    );

  }

//==============================================================================
//========================= getDeliveryBoy API =================================

  Future<void> getDeliveryBoy() async {
    CUR_USERID = await getPrefrence(Id);
    var parameter = {
      SellerId: CUR_USERID,
    };

    apiBaseHelper.postAPICall(getDeliveryBoysApi, parameter).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        print(getDeliveryBoysApi);
        print("DELIVERY BOY ====== $parameter");

        if (!error) {
          delBoyList.clear();
          var data = getdata["data"];
          delBoyList = (data as List)
              .map((data) => new PersonModel.fromJson(data))
              .toList();
          print("DEL BOY LIST======" + delBoyList.toString());
        } else {
          setSnackbar(msg!,context);
        }
      },
      onError: (error) {
        setSnackbar(error.toString(),context);
      },
    );
  }
  Future<Null> getOrderDetail() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      CUR_USERID = await getPrefrence(Id);
      var parameter = {
        SellerId: CUR_USERID,
        Id: widget.id,
      };
      print("GET ORDER API ==== $getOrdersApi");
      print("GET ORDER PARAM ==== $parameter");
      apiBaseHelper.postAPICall(getOrdersApi, parameter).then(
            (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            var data = getdata["data"];
            if (data.length != 0) {
              tempList = (data as List)
                  .map((data) => new Order_Model.fromJson(data))
                  .toList();

              for (int i = 0; i < tempList[0].itemList!.length; i++)
                tempList[0].itemList![i].curSelected =
                    tempList[0].itemList![i].status;

              searchList.addAll(delBoyList);

              if (tempList[0].itemList![0].deliveryBoyId != null){
                selectedDelBoy = delBoyList.indexWhere(
                        (f) => f.id == tempList[0].itemList![0].deliveryBoyId);

              }
              if (selectedDelBoy == -1) {
                selectedDelBoy = null;
              }else{
                if(selectedDelBoy!=null){
                  type =delBoyList[int.parse(selectedDelBoy.toString())].name.toString();
                }

              }

              if (tempList[0].payMethod == "Bank Transfer") {
                statusList.removeWhere((element) => element == PLACED);
              }
              curStatus = tempList[0].itemList![0].activeStatus!;
              deliveryStatus = tempList[0].itemList![0].activeStatus!;
              if (tempList[0].listStatus!.contains(PLACED)) {
                pDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(PLACED)];

                if (pDate != null) {
                  List d = pDate!.split(" ");
                  pDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(PROCESSED)) {
                prDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(PROCESSED)];
                if (prDate != null) {
                  List d = prDate!.split(" ");
                  prDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(SHIPED)) {
                sDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(SHIPED)];
                if (sDate != null) {
                  List d = sDate!.split(" ");
                  sDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(DELIVERD)) {
                dDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(DELIVERD)];
                if (dDate != null) {
                  List d = dDate!.split(" ");
                  dDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(CANCLED)) {
                cDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(CANCLED)];
                if (cDate != null) {
                  List d = cDate!.split(" ");
                  cDate = d[0] + "\n" + d[1];
                }
              }
              if (tempList[0].listStatus!.contains(RETURNED)) {
                rDate = tempList[0]
                    .listDate![tempList[0].listStatus!.indexOf(RETURNED)];
                if (rDate != null) {
                  List d = rDate!.split(" ");
                  rDate = d[0] + "\n" + d[1];
                }
              }
              model = tempList[0];
              _isCancleable = model!.isCancleable == "1" ? true : false;
              _isReturnable = model!.isReturnable == "1" ? true : false;
            } else {
              setSnackbar(msg!,context);
            }
            setState(
                  () {
                isLoading = false;
              },
            );
          } else {}
        },
        onError: (error) {
          setSnackbar(error.toString(),context);
        },
      );
    } else {
      if (mounted)
        setState(
              () {
            _isNetworkAvail = false;
          },
        );
    }

    return null;
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
  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar()));
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
              child: model!=null?Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Container(
                            width: 65.w,
                            child: text(
                              "Order Details",
                              textColor: Color(0xffffffff),
                              fontSize: 14.sp,
                              fontFamily: fontMedium,
                              isCentered: true
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5.91.w),
                            child: PopupMenuButton(
                              icon: Icon(Icons.chat,color: Colors.white,),
                                iconSize:  32,
                                color: Colors.white,
                                onSelected: (val){
                                      if(val =="Driver"){
                                        driverName = model!.drivername.toString();
                                        driverEmail =model!.driveremail.toString();
                                        driverFcmID = model!.driverfcm.toString();
                                        driverFid = model!.driverfuid.toString();
                                        if(driverFid!=""&&driverFid!=null&&driverFid!="0"){
                                          callChatDriver();
                                        }else{
                                          setSnackbar("Currently Not Available", context);
                                        }
                                      }else{
                                        userName = model!.username.toString();
                                        userEmail =model!.useremail.toString();
                                        fcmID = model!.userfcm_id.toString();
                                        fid = model!.userfuid.toString();
                                        if(fid!=""&&fid!=null&&fid!="0"){
                                          callChatUser();
                                        }else{
                                          setSnackbar("Currently Not Available", context);
                                        }
                                      }
                                },
                                itemBuilder: (_) =><PopupMenuItem<String>>[
                              PopupMenuItem(child: text("Driver",textColor: Colors.black),value: "driver",),
                              PopupMenuItem(child: text("User",textColor: Colors.black),value: "user",),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 43.98.h,
                    child: MapPage(
                      SOURCE_LOCATION: LatLng(double.parse(model!.latitude.toString()),double.parse(model!.longitude.toString())),
                      DEST_LOCATION: LatLng(double.parse(model!.sellerLat.toString()),double.parse(model!.sellerLng.toString())),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 8.33.w, right: 8.33.w, top: 1.87.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Order #${model!.id.toString()} |",
                                textColor:Color(0xff000833),
                                fontSize: 13.sp,
                                fontFamily: fontBold,
                              ),
                              text(
                                  calculateDistance(double.parse(model!.latitude.toString()),double.parse(model!.longitude.toString()), double.parse(model!.sellerLat.toString()),double.parse(model!.sellerLng.toString())).toStringAsFixed(1)+"Km",
                                textColor: Color(0xff13CE3F),
                                fontSize: 13.sp,
                                fontFamily: fontBold,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              text(
                                "Earning  ",
                                textColor: Color(0xff000000),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              text(
                                "₹${model!.payable}",
                                textColor: AppColor().colorTextThird(),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                          "${model!.itemList!.length} Items",
                          textColor: Color(0xff000000),
                          fontSize: 7.sp,
                          fontFamily: fontRegular,
                        ),
                        Padding(
                          padding:  EdgeInsets.only(right: 11.0.w),
                          child: text(
                            "Amount",
                            textColor: Color(0xff000000),
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(width: 3.12.h,),
                  Container(
                    margin:
                        EdgeInsets.only(left: 8.33.w, right: 8.33.w, top: 1.87.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                          "Payment : ${model!.payMethod!}",
                          textColor: Color(0xff13CE3F),
                          fontSize: 10.sp,
                          fontFamily: fontSemibold,
                        ),
                        text(
                          model!.orderDate!,
                          textColor: Color(0xff2E2E2E),
                          fontSize: 7.5.sp,
                          fontFamily: fontSemibold,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 8.33.w, right: 8.33.w, top: 1.87.h),
                    child: Divider(
                      height: 1.0,
                      color: Color(0xff707070),
                    ),
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  text(
                    "Pickup Details",
                    textColor: Color(0xffFD531F),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                    padding:
                        EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                    height: 23.82.h,
                    decoration: boxDecoration(
                      showShadow: true,
                      radius: 20.0,
                      bgColor: AppColor().colorBg1(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      "Store Name",
                                      textColor: Color(0xff000000),
                                      fontSize: 10.sp,
                                      fontFamily: fontBold,
                                    ),
                                    SizedBox(
                                      height: 1.02.h,
                                    ),
                                    text(
                                      name,
                                      textColor: Color(0xff757575),
                                      fontSize: 10.sp,
                                      fontFamily: fontSemibold,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      "Store Contact No.",
                                      textColor: Color(0xff000000),
                                      fontSize: 10.sp,
                                      fontFamily: fontBold,
                                    ),
                                    SizedBox(
                                      height: 1.02.h,
                                    ),
                                    text(
                                      contact,
                                      textColor: Color(0xff757575),
                                      fontSize: 10.sp,
                                      fontFamily: fontSemibold,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.42.h,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Store Address",
                                textColor: Color(0xff000000),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                              SizedBox(
                                height: 1.02.h,
                              ),
                              text(
                                  address,
                                  textColor: Color(0xff757575),
                                  fontSize: 9.sp,
                                  fontFamily: fontSemibold,
                                  maxLine: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  text(
                    "Delivery Details",
                    textColor: Color(0xffFD531F),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                    padding:
                    EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                    height: 23.82.h,
                    decoration: boxDecoration(
                      showShadow: true,
                      radius: 20.0,
                      bgColor: AppColor().colorBg1(),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      "Delivery Name",
                                      textColor: Color(0xff000000),
                                      fontSize: 10.sp,
                                      fontFamily: fontBold,
                                    ),
                                    SizedBox(
                                      height: 1.02.h,
                                    ),
                                    text(
                                      model!.name.toString(),
                                      textColor: Color(0xff757575),
                                      fontSize: 10.sp,
                                      fontFamily: fontSemibold,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    text(
                                      "Delivery Mobile No.",
                                      textColor: Color(0xff000000),
                                      fontSize: 10.sp,
                                      fontFamily: fontBold,
                                    ),
                                    SizedBox(
                                      height: 1.02.h,
                                    ),
                                    text(
                                      model!.mobile.toString(),
                                      textColor: Color(0xff757575),
                                      fontSize: 10.sp,
                                      fontFamily: fontSemibold,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.42.h,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                "Delivery Address",
                                textColor: Color(0xff000000),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                              SizedBox(
                                height: 1.02.h,
                              ),
                              text(
                                   model!.address.toString(),
                                  textColor: Color(0xff757575),
                                  fontSize: 9.sp,
                                  fontFamily: fontSemibold,
                                  maxLine: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  text(
                    "Special Delivery instructions",
                    textColor: Color(0xffFD531F),
                    fontSize: 14.sp,
                    fontFamily: fontBold,
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                    padding:
                        EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                    height: 13.32.h,
                    decoration: boxDecoration(
                      showShadow: true,
                      radius: 20.0,
                      bgColor: AppColor().colorBg1(),
                    ),
                    child:  Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                              "-Delivery Time Must Be In Between ${model!.delDate!} - ${model!.delTime!}",
                              textColor: Color(0xff757575),
                              fontSize: 8.sp,
                              fontFamily: fontRegular,
                              maxLine: 2),
                          SizedBox(
                            height: 1.02.h,
                          ),
                          text(
                              "-Delivery Boy Must Wear Mask and Must Follow All Covid Protocol",
                              textColor: Color(0xff757575),
                              fontSize: 9.sp,
                              fontFamily: fontRegular,
                              maxLine: 2),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  DottedBorder(
                    color: Color(0xff707070),
                    strokeWidth: 1,
                    dashPattern: [3],
                    strokeCap: StrokeCap.square,
                    radius: const Radius.circular(10),
                    child: Container(
                      width: 55.69.w,
                      height: 4.37.h,
                      child: Center(
                        child: text(
                          "Parcel Details",
                          textColor: Color(0xffFD531F),
                          fontSize: 14.sp,
                          fontFamily: fontBold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                    padding:
                    EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                    height: 5.92.h,
                   color: Color(0xffEAEAEA),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(
                                "Product Name",
                                textColor:  Color(0xff000833),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                              text(
                                "Quantity",
                                textColor:  Color(0xff000833),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                              text(
                                "Price",
                                textColor:  Color(0xff000833),
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: model!.itemList!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      OrderItem orderItem =
                      model!.itemList![i];
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                            padding:
                            EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                            color: Color(0xffffffff),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25.w,
                                        child: text(
                                          orderItem.name.toString(),
                                          textColor: Color(0xff000833),
                                          fontSize: 10.sp,
                                          fontFamily: fontRegular,
                                        ),
                                      ),
                                      text(
                                        orderItem.qty.toString(),
                                        textColor: Color(0xff000833),
                                        fontSize: 10.sp,
                                        fontFamily: fontRegular,
                                      ),
                                      text(
                                        "₹${orderItem.price.toString()}",
                                        textColor: Color(0xff000833),
                                        fontSize: 10.sp,
                                        fontFamily: fontRegular,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.only(left: 8.33.w, right: 8.33.w),
                            child: Divider(
                              height: 1.0,
                              color: Color(0xff707070),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 1.52.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 2.91.w, right: 2.91.w, top: 2.67.h),
                    height: !show?17.h+62.62.h:62.62.h,
                    width: 83.88.w,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      tileMode: TileMode.clamp,
                      colors: [
                        AppColor().colorBg1(),
                        AppColor().colorBg2(),
                      ],
                    )),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1.52.h,
                        ),
                        DottedBorder(
                          color: Color(0xff707070),
                          strokeWidth: 1,
                          dashPattern: [3],
                          strokeCap: StrokeCap.square,
                          radius: const Radius.circular(10),
                          child: Container(
                            width: 55.69.w,
                            height: 4.37.h,
                            child: Center(
                              child: text(
                                "Assign To delivery Boy",
                                textColor: Color(0xffFD531F),
                                fontSize: 14.sp,
                                fontFamily: fontBold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.02.h,
                        ),
                        Center(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                show=!show;
                              });
                            },
                            child: Container(
                              width: 86.80.w,
                              height: 7.42.h,
                              decoration: boxDecoration(
                                radius: 10,
                                bgColor: AppColor().colorBg1(),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5.w,),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text(
                                    "${model!.drivername}",
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: AppColor().colorTextPrimary(),
                                  ),
                                  Image.asset(down,height: 2.h,color: AppColor().colorTextPrimary(),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        model!.itemList![0].activeStatus!=DELIVERD
                            ? Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            height: show ? 0.h :17.h,
                            width: 86.80.w,
                            decoration: boxDecoration(
                              radius: 10,
                              bgColor: AppColor().colorBg2(),
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: delBoyList.length,
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        type=delBoyList[index].name.toString();
                                        selectedDelBoy = index;
                                        show=true;
                                        model!.drivername = type;
                                      });
                                      print("SELECT === $selectedDelBoy");
                                    },
                                    child: Container(
                                      width: 86.80.w,
                                      height: 5.71.h,
                                      color: type.toString().contains(delBoyList[index].name.toString())? Color(0xffFFE7AB):AppColor().colorBg1(),
                                      padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.09.h),
                                      child:  text(
                                        delBoyList[index].name.toString(),
                                        fontSize: 10.sp,
                                        fontFamily: fontMedium,
                                        textColor: AppColor().colorTextPrimary(),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                            : SizedBox(),

                        /*model!.drivername!=null?Center(
                          child: Container(
                            width: 86.80.w,
                            height: 7.42.h,
                            decoration: boxDecoration(
                              radius: 10,
                              bgColor: AppColor().colorBg2(),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.w,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                  model!.drivername.toString(),
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  textColor: AppColor().colorTextPrimary(),
                                ),
                              ],
                            ),
                          ),
                        ):SizedBox(),*/

                        SizedBox(
                          height: 1.52.h,
                        ),
                        DottedBorder(
                          color: Color(0xff707070),
                          strokeWidth: 1,
                          dashPattern: [3],
                          strokeCap: StrokeCap.square,
                          radius: const Radius.circular(10),
                          child: Container(
                            width: 55.69.w,
                            height: 4.37.h,
                            child: Center(
                              child: text(
                                "Delivery Status",
                                textColor: Color(0xff8A8787),
                                fontSize: 14.sp,
                                fontFamily: fontBold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.02.h,
                        ),
                        Image(
                          image: AssetImage(
                              greenIcon),
                          fit: BoxFit.fill,
                          height: 3.20.h,
                          width: 3.20.h,

                        ),
                        SizedBox(
                          height: 1.02.h,
                        ),
                        text(
                           curStatus.toString().toUpperCase(),
                          textColor:   Color(0xff8A8787),
                          fontSize: 10.5.sp,
                          fontFamily: fontRegular,
                        ),
                        SizedBox(
                          height: 2.02.h,
                        ),
                        Center(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                show1=!show1;
                              });
                            },
                            child: Container(
                              width: 86.80.w,
                              height: 7.42.h,
                              decoration: boxDecoration(
                                radius: 10,
                                bgColor: AppColor().colorBg1(),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5.w,),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text(
                                    deliveryStatus,
                                    fontSize: 10.sp,
                                    fontFamily: fontMedium,
                                    textColor: AppColor().colorTextPrimary(),
                                  ),
                                  Image.asset(down,height: 2.h,color: AppColor().colorTextPrimary(),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            height: show1 ? 0.h : 17.h,
                            width: 86.80.w,
                            decoration: boxDecoration(
                              radius: 10,
                              bgColor: AppColor().colorBg2(),
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: statusList.length,
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        deliveryStatus=statusList[index].toString();
                                        show1=true;
                                        curStatus = deliveryStatus;
                                      });
                                    },
                                    child: Container(
                                      width: 86.80.w,
                                      height: 4.71.h,
                                      color: deliveryStatus.toString().contains(statusList[index].toString())? Color(0xffFFE7AB):AppColor().colorBg1(),
                                      padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.09.h),
                                      child:  text(
                                        statusList[index].toString(),
                                        fontSize: 10.sp,
                                        fontFamily: fontMedium,
                                        textColor: AppColor().colorTextPrimary(),
                                      ),
                                    ),
                                  );
                                }),
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
                        updateOrder(
                          curStatus,
                          updateOrderItemApi,
                          model!.id,
                          true,
                          0,
                        );
                       /* if(model!.itemList![0].accept_reject=="1"){

                        }else{
                          setSnackbar("Please accept order first.", context);
                        }*/
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
                              "Update",
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
              ):Center(child: CircularProgressIndicator(),),
            ),
          ),
        ):noInternet(context),
      ),
    );
  }
  Future<void> updateOrder(
      String? status,
      Uri api,
      String? id,
      bool item,
      int index,
      ) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (true) {
      if (_isNetworkAvail) {
        try {
          var parameter = {
            STATUS: status,
          };
          List<String> ids = [];
          for(int i=0;i<model!.itemList!.length;i++){
            ids.add(tempList[0].itemList![i].id.toString());
          }
          if (item) {
            parameter[ORDERITEMID] = ids.join(",");
          }
       /*   if (item) {
            parameter[ORDERITEMID] = tempList[0].itemList![index].id;
          }*/
          if (selectedDelBoy != null)
            parameter[DEL_BOY_ID] = delBoyList[selectedDelBoy!].id;

          print("UPDATE====" +parameter.toString());

          apiBaseHelper.postAPICall(updateOrderItemApi, parameter).then(
                (getdata) async {
              bool error = getdata["error"];
              String msg = getdata["message"];
              setSnackbar(msg,context);
              print("msg : $msg");
              if (!error) {
                if (item)
                  tempList[0].itemList![index].status = status;
                else
                  tempList[0].itemList![0].activeStatus = status;

                if (selectedDelBoy != null)
                  tempList[0].itemList![0].deliveryBoyId =
                      delBoyList[selectedDelBoy!].id;
                getOrderDetail();
              } else {
                getOrderDetail();
              }
            },
            onError: (error) {
              setSnackbar(error.toString(),context);
            },
          );
        } on TimeoutException catch (_) {
          setSnackbar(getTranslated(context, "somethingMSg")!,context);
        }
      } else {
        setState(() {
          _isNetworkAvail = false;
        });
      }
    } else {
      setSnackbar('You have not authorized permission for update order!!',context);
    }
  }
  String userEmail = "paliwalpravin1@gmail.com", driverEmail = "";
  String userName = "Praveen", fid="",fcmID= "";
  String driverName = "Praveen", driverFid="",driverFcmID= "";
  String uid = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  callChatUser() async {
    await App.init();
    if (App.localStorage.getString("firebaseUid") != null) {
      uid = App.localStorage.getString("firebaseUid").toString();
      var otherUser1 = types.User(
        firstName: userName,
        id: fid,
        imageUrl: 'https://i.pravatar.cc/300?u=$userEmail',
        lastName: "",
      );
      _handlePressed(otherUser1, context,fcmID,userName);
    }
  }
  callChatDriver() async {
    await App.init();
    if (App.localStorage.getString("firebaseUid") != null) {
      uid = App.localStorage.getString("firebaseUid").toString();
      var otherUser1 = types.User(
        firstName: driverName,
        id: driverFid,
        imageUrl: 'https://i.pravatar.cc/300?u=$driverEmail',
        lastName: "",
      );
      _handlePressed(otherUser1, context,driverFcmID,driverName);
    }
  }

  _handlePressed(types.User otherUser, BuildContext context,String fcmID,name) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
          fcm: fcmID,
          name: name,
        ),
      ),
    );
  }
}
