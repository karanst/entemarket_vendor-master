
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Model/OrdersModel/OrderModel.dart';
import 'package:ziberto_vendor/NewScreen/order_history_details.dart';
import 'package:ziberto_vendor/Screen/Home.dart';

import 'bottom_bar.dart';
import 'order_filter.dart';

class MainOrderHistory extends StatefulWidget {
  // const MainOrderHistory({Key? key}) : super(key: key);
  @override
  State<MainOrderHistory> createState() => _MainOrderHistoryState();
}

class _MainOrderHistoryState extends State<MainOrderHistory> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  TextEditingController searchController = new TextEditingController();
  List<Order_Model> tempList = [];
  bool isSwitched = false;
  String? activeStatus;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String? start, end;
  bool _isNetworkAvail = true;
  AnimationController? buttonController;
  String _searchText = "", _lastsearch = "";
  int scrollOffset = 0;
  ScrollController? scrollController;
  bool scrollLoadmore = true, scrollGettingData = false, scrollNodata = false;
  bool? isSearching;
  String? all,
      received,
      processed,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController(keepScrollOffset: true);
    scrollController!.addListener(_transactionscrollListener);
    getSaveDetail();
    getSallerDetail();
    getOrder();
  }
  _transactionscrollListener() {
    if (scrollController!.offset >=
        scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange) {
      if (mounted)
        setState(
              () {
            scrollLoadmore = true;
            getOrder();
          },
        );
    }
  }
  String address="",lat="",lon="";
  getSaveDetail() async {
    print("we are here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    address = await getPrefrence(Address) ?? '';
    lat = await getPrefrence(Latitude) ?? '';
    lon = await getPrefrence(Longitude) ?? '';
  }
  Future<Null> getSallerDetail() async {
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
            LOGO = data["logo"].toString();
            RATTING = data[Rating] ?? "";
            NO_OFF_RATTING = data[NoOfRatings] ?? "";
            NO_OFF_RATTING = data[NoOfRatings] ?? "";
            var id = data[Id];
            var username = data[Username];
            var email = data[Email];
            var mobile = data[Mobile];
            var address = data[Address];
            CUR_USERID = id!;
            CUR_USERNAME = username!;
            var srorename = data[Storename];
            var storeurl = data[Storeurl];
            var storeDesc = data[storeDescription];
            var accNo = data[accountNumber];
            var accname = data[accountName];
            var bankCode = data[BankCOde];
            var bankName = data[bankNAme];
            var latitutute = data[Latitude];
            var longitude = data[Longitude];
            var taxname = data[taxName];
            var tax_number = data[taxNumber];
            var pan_number = data[panNumber];
            var status = data[STATUS];
            var storeLogo = data[StoreLogo];

            print("bank name : $bankName");
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
  String dateType = "6";
  bool isSameDate(DateTime date1,DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month
        && date1.day == date2.day;
  }
  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar()));
    return Future.value(true);
  }
  String filter = "all";
  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: _key,
          endDrawer: Drawer(child: Oredrfilter(onResult: (result)async{
                    setState(() {
                      activeStatus  = result['type'];
                      filter = result['date'];
                      scrollLoadmore = true;
                      scrollOffset = 0;
                    });
                    print(activeStatus);
                    await getOrder();
          },)),
          body: Container(
            child: SingleChildScrollView(
              controller: scrollController,
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
                              "Order History",
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
                  SizedBox(height: 2.h,),
                  Container(
                    width: 90.w,
                    height: 6.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: mysize.width * 0.7,
                          decoration: BoxDecoration(color: MyColor.greyLight),
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value){
                              setState(() {
                                _searchText = value;
                                scrollLoadmore = true;
                                scrollOffset = 0;
                              });
                              getOrder();
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search), labelText: 'Search'),
                          ),
                        ),
                        InkWell(
                          onTap: () => onTapOpenFiler(context),
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'images/filter.png',
                              height: 4.h,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  orderList.length>0?ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderList.length,
                      itemBuilder: (context,index){
                        Order_Model? item;
                        try {
                          item = orderList.isEmpty ? null : orderList[index];
                          if (scrollLoadmore &&
                              index == (orderList.length - 1) &&
                              scrollController!.position.pixels <= 0) {
                            getOrder();
                          }
                        } on Exception catch (_) {}
                        return InkWell(
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                // ServiceScreenDetails(id: item!.id.toString(),))
                            // );
                          },
                          child: Container(
                            width: 93.33.w,
                            margin: EdgeInsets.only(bottom:1.87.h
                            ),
                            decoration:
                            boxDecoration(radius: 32.0, bgColor: AppColor().colorBg1()),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 3.44.w,right: 3.44.w,top: 3.90.h,),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 6.81.h,
                                          width: 6.81.h,
                                          child: Image(
                                            image:AssetImage(cardPerson),
                                            fit: BoxFit.fill,
                                          )),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        text(
                                                          "Order #${item!.id.toString()} |",
                                                          textColor: Color(0xff191919),
                                                          fontSize: 13.sp,
                                                          fontFamily: fontBold,
                                                        ),
                                                        item.latitude!=null && item.longitude != null
                                                            &&  item.latitude!="" && item.longitude != ""
                                                            ?
                                                        text(
                                                          calculateDistance(double.parse(item.latitude.toString()),double.parse(item.longitude.toString()), double.parse(item.sellerLat.toString()),double.parse(item.sellerLng.toString())).toStringAsFixed(1)+"Km",
                                                          textColor: Color(0xff13CE3F),
                                                          fontSize: 13.sp,
                                                          fontFamily: fontBold,
                                                        ):SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width:  3.34.w,),
                                                  Container(
                                                    child:  text(
                                                      "${item.orderDate}",
                                                      textColor: Color(0xff191919),
                                                      fontSize: 7.sp,
                                                      fontFamily: fontRegular,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height:  1.54.h,),
                                            Container(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Order Assigned ${getMinute(item.dateTime!)} min ago",
                                                    textColor: Color(0xff191919),
                                                    fontSize: 7.sp,
                                                    fontFamily: fontRegular,
                                                  ),
                                                  SizedBox(width:  3.34.w,),
                                                  text(
                                                    "Earning Amount : ₹${item.payable.toString()}",
                                                    textColor: Color(0xffBF2330),
                                                    fontSize: 7.sp,
                                                    fontFamily: fontBold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 2.5.h,
                                          width: 2.5.h,
                                          child: Image(
                                            image:AssetImage(yellowLocation),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 1.w,),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              text(
                                                "Pick up Point",
                                                textColor: Color(0xff191919),
                                                fontSize: 7.5.sp,
                                                fontFamily: fontBold,
                                              ),
                                              Container(
                                                width: 60.w,
                                                child: text(
                                                  address,
                                                  textColor: Color(0xffAEABAB),
                                                  fontSize: 9.sp,
                                                  fontFamily: fontRegular,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 2.5.h,
                                          width: 2.5.h,
                                          child: Image(
                                            image:AssetImage(redLocation),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 1.w,),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              text(
                                                "Drop Point",
                                                textColor: Color(0xff191919),
                                                fontSize: 7.5.sp,
                                                fontFamily: fontBold,
                                              ),
                                              Container(
                                                width: 60.w,
                                                child: text(
                                                  item.address.toString(),
                                                  textColor: Color(0xffAEABAB),
                                                  fontSize: 9.sp,
                                                  fontFamily: fontRegular,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                // item.itemList![0].activeStatus==PLACED?!loading ?
                                // Container(
                                //   margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.5.h),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       InkWell(
                                //         onTap: (){
                                //           updateOrder(
                                //             item,
                                //             CANCLED,
                                //             updateOrderItemApi,
                                //             item!.id,
                                //             true,
                                //             0,
                                //           );
                                //           //acceptStatus(item!.id, "2");
                                //         },
                                //         child: Container(
                                //           width: 32.77.w,
                                //           height: 4.92.h,
                                //           margin: EdgeInsets.only(right: 2.w),
                                //           decoration: boxDecoration(
                                //             radius: 6.0,
                                //             bgColor:AppColor().colorTextThird(),
                                //           ),
                                //           child: Center(
                                //             child: text(
                                //               "Reject",
                                //               textColor: AppColor().colorBg1(),
                                //               fontSize: 10.sp,
                                //               fontFamily: fontRegular,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       InkWell(
                                //         onTap: (){
                                //           updateOrder(
                                //             item,
                                //             PROCESSED,
                                //             updateOrderItemApi,
                                //             item!.id,
                                //             true,
                                //             0,
                                //           );
                                //         },
                                //         child: Container(
                                //           width: 32.77.w,
                                //           height: 4.92.h,
                                //           margin: EdgeInsets.only(right: 2.w),
                                //           decoration: boxDecoration(
                                //             radius: 6.0,
                                //             //color:AppColor().colorPrimaryDark(),
                                //             bgColor: Color(0xff13CE3F),
                                //           ),
                                //           child: Center(
                                //             child: text(
                                //               "Accept",
                                //               textColor: AppColor().colorBg1(),
                                //               fontSize: 10.sp,
                                //               fontFamily: fontRegular,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ):Center(child: CircularProgressIndicator(),):SizedBox()

                                /*  Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ServiceScreenDetails()));
                                      },
                                      child: Container(
                                        width: 32.77.w,
                                        height: 4.92.h,
                                        margin: EdgeInsets.only(right: 2.w),
                                        decoration: boxDecoration(
                                          radius: 6.0,
                                          bgColor:AppColor().colorTextThird(),
                                        ),
                                        child: Center(
                                          child: text(
                                            "Reject",
                                            textColor: AppColor().colorBg1(),
                                            fontSize: 10.sp,
                                            fontFamily: fontRegular,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 32.77.w,
                                      height: 4.92.h,
                                      margin: EdgeInsets.only(right: 2.w),
                                      decoration: boxDecoration(
                                        radius: 6.0,
                                        //color:AppColor().colorPrimaryDark(),
                                        bgColor: Color(0xff13CE3F),
                                      ),
                                      child: Center(
                                        child: text(
                                          "Accept",
                                          textColor: AppColor().colorBg1(),
                                          fontSize: 10.sp,
                                          fontFamily: fontRegular,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )*/
                              ],
                            ),
                          ),
                        );
                      }):Container(
                    height: 30.h,
                    child: Center(child: text("No Order Available",fontSize: 14.sp,fontFamily: fontBold,textColor: Colors.black)),) ,
                    //   : Container(
                    // height: 30.h,
                    // child: Center(child: text("You are offline",fontSize: 14.sp,fontFamily: fontBold,textColor: Colors.black)),),
                  // my card view
                  Container(
                    width: 90.w,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: orderList.length,
                        itemBuilder: (context, int i) {
                          late Order_Model model;
                          try {
                            model =
                            (orderList.isEmpty ? null : orderList[i])!;
                            if (scrollLoadmore &&
                                i == (orderList.length - 1) &&
                                scrollController!.position.pixels <= 0) {
                              getOrder();
                            }
                          } on Exception catch (_) {}
                          return model.itemList![0].activeStatus!=PLACED?InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderHistoryDetails(id: model.id.toString(),)));

                            },
                            child:  Container(
                              margin: EdgeInsets.only(bottom:1.87.h
                              ),
                              padding: EdgeInsets.all(2.w),
                              decoration:
                              boxDecoration(radius: 15.0, bgColor: AppColor().colorBg1(),showShadow: true),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // fast row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: mysize.width / 4.5,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order ID',
                                                  style: TextStyle(fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  '#${model.id}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: MyColor.greyText),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.symmetric(horizontal: 4),
                                            child: VerticalDivider(
                                              color: MyColor.greyText,
                                              width: 5,
                                            ),
                                          ),
                                          SizedBox(
                                            width: mysize.width / 3.5,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date/ Time',
                                                  style: TextStyle(fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  '${model.dateTime}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: MyColor.greyText),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.symmetric(horizontal: 4),
                                            child: VerticalDivider(
                                              color: MyColor.greyText,
                                              width: 5,
                                            ),
                                          ),
                                          // new
                                          SizedBox(
                                            width: mysize.width / 7,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Charge',
                                                  style: TextStyle(fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  "₹" + model.payable.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: MyColor.greyText),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              // height: 40,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    model.itemList![0].activeStatus.toString()=="delivered"?'images/grren.png':"images/red.png",
                                                    height: 25,
                                                  ),
                                                  Container(
                                                    // width: mysize.width / 3,
                                                    child: Text(
                                                      model.itemList![0].activeStatus.toString()[0].toUpperCase()+model.itemList![0].activeStatus.toString().substring(1),
                                                      style: TextStyle(fontSize: 9),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // fast row
                                      Divider(),
// second row
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 2.5.h,
                                                width: 2.5.h,
                                                child: Image(
                                                  image:AssetImage(yellowLocation),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(width: 1.w,),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      "Pick up Point",
                                                      textColor: Color(0xff191919),
                                                      fontSize: 7.5.sp,
                                                      fontFamily: fontBold,
                                                    ),
                                                    Container(
                                                      width: 60.w,
                                                      child: text(
                                                        address,
                                                        textColor: Color(0xffAEABAB),
                                                        fontSize: 9.sp,
                                                        fontFamily: fontRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.50.h),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 2.5.h,
                                                width: 2.5.h,
                                                child: Image(
                                                  image:AssetImage(redLocation),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(width: 1.w,),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    text(
                                                      "Drop Point",
                                                      textColor: Color(0xff191919),
                                                      fontSize: 7.5.sp,
                                                      fontFamily: fontBold,
                                                    ),
                                                    Container(
                                                      width: 60.w,
                                                      child: text(
                                                        model.address.toString(),
                                                        textColor: Color(0xffAEABAB),
                                                        fontSize: 9.sp,
                                                        fontFamily: fontRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      // new

// second row
                                    ],
                                  ),
                                )):SizedBox();
                        }),
                  ),
                  scrollGettingData
                      ? Center(
                    child: Container(
                      padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTapOpenFiler(context) {
    _key.currentState!.openEndDrawer();
  }
  Future<Null> getOrder() async {
    if (readOrder) {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        if (scrollLoadmore) {
          if (mounted)
            setState(() {
              scrollLoadmore = false;
              scrollGettingData = true;
              if (scrollOffset == 0) {
                orderList = [];
              }
            });
          CUR_USERID = await getPrefrence(Id);
          CUR_USERNAME = await getPrefrence(Username);

          var parameter = {
            SellerId: CUR_USERID,
            LIMIT: perPage.toString(),
            OFFSET: scrollOffset.toString(),
            SEARCH: _searchText.trim(),
            "filter":filter,
          };
          if (start != null)
            parameter[START_DATE] = "${startDate.toLocal()}".split(' ')[0];
          if (end != null)
            parameter[END_DATE] = "${endDate.toLocal()}".split(' ')[0];
          if (activeStatus != null) {
            if (activeStatus == awaitingPayment) activeStatus = "all";
            parameter[ActiveStatus] = activeStatus!;
          }

          apiBaseHelper.postAPICall(getOrdersApi, parameter).then(
                (getdata) async {
              bool error = getdata["error"];
              String? msg = getdata["message"];
              scrollGettingData = false;
              if (scrollOffset == 0) scrollNodata = error;

              if (!error) {
                all = getdata["total"];
                received = getdata["received"];
                processed = getdata["processed"];
                shipped = getdata["shipped"];
                delivered = getdata["delivered"];
                cancelled = getdata["cancelled"];
                returned = getdata["returned"];
                awaiting = getdata["awaiting"];
                tempList.clear();
                var data = getdata["data"];
                print("data : $data");
                if (data.length != 0) {
                  tempList = (data as List)
                      .map((data) => new Order_Model.fromJson(data))
                      .toList();

                  orderList.addAll(tempList);
                  scrollLoadmore = true;
                  scrollOffset = scrollOffset + perPage;
                } else {
                  scrollLoadmore = false;
                }
              } else {
                scrollLoadmore = false;
              }
              if (mounted)
                setState(() {
                  scrollLoadmore = false;
                });
            },
            onError: (error) {
              setSnackbar(error.toString(),context);
            },
          );
        }
      } else {
        if (mounted)
          setState(
                () {
              _isNetworkAvail = false;
              scrollLoadmore = false;
            },
          );
      }
      return null;
    } else {
      setSnackbar('You have not authorized permission for read order!!',context);
    }
  }
}
