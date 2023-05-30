
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/PushNotificationService.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Model/CategoryModel/categoryModel.dart';
import 'package:ziberto_vendor/Model/OrdersModel/OrderModel.dart';
import 'package:ziberto_vendor/NewScreen/payment_screen.dart';
import 'package:ziberto_vendor/NewScreen/service_details_screen.dart';
import 'package:ziberto_vendor/Screen/Customers.dart';
import 'package:ziberto_vendor/Screen/Home.dart';
import 'package:ziberto_vendor/Screen/OrderList.dart';
import 'package:ziberto_vendor/Screen/ProductList.dart';
import 'package:ziberto_vendor/Screen/WalletHistory.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../Model/SellerStatusModel.dart';
import 'main_order_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  List<Order_Model> tempList = [];
  bool isSwitched = false;
  String? activeStatus="received";
  var openCloseStatus;
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
  int curChart = 0;
  Map<int, LineChartData>? chartList;
  List? days = [], dayEarning = [];
  List? months = [], monthEarning = [];
  List? weeks = [], weekEarning = [];
  List? catCountList = [], catList = [];
  List colorList = [];
  int? touchedIndex;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
  ];
  String? totalorderCount,
      totalproductCount,
      totalcustCount,
      totaldelBoyCount,
      totalsoldOutCount,
      totallowStockCount;
  Future<Null> getStatics() async {
    CUR_USERID = await getPrefrence(Id);
    CUR_USERNAME = await getPrefrence(Username);
    var parameter = {SellerId: CUR_USERID};

    apiBaseHelper.postAPICall(getStatisticsApi, parameter).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          setState((){
            CUR_CURRENCY = getdata["currency_symbol"];
            var count = getdata['counts'][0];
            totalorderCount = count["order_counter"];
            totalproductCount = count["product_counter"];
            totalsoldOutCount = count['count_products_sold_out_status'];
            totallowStockCount = count["count_products_low_status"];
            totalcustCount = count["user_counter"];
            delPermission = count["permissions"]['assign_delivery_boy'].toString();
            weekEarning = getdata['earnings'][0]["weekly_earnings"]['total_sale'];
            days = getdata['earnings'][0]["daily_earnings"]['day'];
            dayEarning = getdata['earnings'][0]["daily_earnings"]['total_sale'];
            months = getdata['earnings'][0]["monthly_earnings"]['month_name'];
            monthEarning =
            getdata['earnings'][0]["monthly_earnings"]['total_sale'];

            weeks = getdata['earnings'][0]["weekly_earnings"]['week'];
            //  if (chartList != null) chartList!.clear();
            chartList = {0: dayData(), 1: weekData(), 2: monthData()};

            catCountList = getdata['category_wise_product_count']['counter'];
            catList = getdata['category_wise_product_count']['cat_name'];
            colorList.clear();
            for (int i = 0; i < catList!.length; i++)
              colorList.add(generateRandomColor());
          }
          );

        } else {
          setSnackbar(msg!,context);
        }

      },
      onError: (error) {
        setSnackbar(error.toString(),context);
      },
    );
    return null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController(keepScrollOffset: true);
    scrollController!.addListener(_transactionscrollListener);
    chartList = {0: dayData(), 1: weekData(), 2: monthData()};
    getFid();
    getSaveDetail();
    getStatics();
    getSallerDetail();
    getCategories();
    getOrder();
  }
  Future<void> getCategories() async {
    CUR_USERID = await getPrefrence(Id);
    var parameter = {
      SellerId: CUR_USERID,
    };
    apiBaseHelper.postAPICall(getCategoriesApi, parameter).then(
          (getdata) async {
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          catagoryList.clear();
          var data = getdata["data"];
          catagoryList = (data as List)
              .map((data) => new CategoryModel.fromJson(data))
              .toList();
        } else {
          setSnackbar(msg!,context);
        }
      },
      onError: (error) {
        setSnackbar(error.toString(),context);
      },
    );
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
      print(getSellerDetails);
      print(parameter);
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
            sellerName = username;
            var email = data[Email];
            sellerEmail = email;
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
            setState(() {
              isSwitched = data["permissions"]["open_close_status"]=="1"?true:false;
            });
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

            callChat();
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
  getChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        height: 250,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 10, left: 5, right: 15),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    getTranslated(context, "ProductSales")!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: primary),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: curChart == 0
                        ? TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: primary,
                      onSurface: Colors.grey,
                    )
                        : null,
                    onPressed: () {
                      setState(
                            () {
                          curChart = 0;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Day")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 1
                        ? TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: primary,
                      onSurface: Colors.grey,
                    )
                        : null,
                    onPressed: () {
                      setState(
                            () {
                          curChart = 1;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Week")!,
                    ),
                  ),
                  TextButton(
                    style: curChart == 2
                        ? TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: primary,
                      onSurface: Colors.grey,
                    )
                        : null,
                    onPressed: () {
                      setState(
                            () {
                          curChart = 2;
                        },
                      );
                    },
                    child: Text(
                      getTranslated(context, "Month")!,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: LineChart(
                  chartList![curChart]!,
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
  //1. LineChartData

  LineChartData dayData() {
    if (dayEarning!.length == 0) {
      dayEarning!.add(0);
      days!.add(0);
    }
    List<FlSpot> spots = dayEarning!.asMap().entries.map((e) {
      return FlSpot(double.parse(days![e.key].toString()),
          double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 3,
            getTextStyles: (context, value) => const TextStyle(
              color: black,
              fontSize: 9,
            ),
            margin: 10,
            getTitles: (value) {
              return value.toInt().toString();
            }),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  //2. catChart

  LineChartData weekData() {
    if (weekEarning!.length == 0) {
      weekEarning!.add(0);
      weeks!.add(0);
    }
    List<FlSpot> spots = weekEarning!.asMap().entries.map((e) {
      return FlSpot(
          double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [
              primary.withOpacity(0.5),
            ],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 4,
            getTextStyles: (context, value) => const TextStyle(
              color: black,
              fontSize: 9,
            ),
            margin: 10,
            getTitles: (value) {
              return weeks![value.toInt()].toString();
            }),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  //2. monthData

  LineChartData monthData() {
    if (monthEarning!.length == 0) {
      monthEarning!.add(0);
      months!.add(0);
    }

    List<FlSpot> spots = monthEarning!.asMap().entries.map((e) {
      return FlSpot(
          double.parse(e.key.toString()), double.parse(e.value.toString()));
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 2,
          colors: [
            grad2Color,
          ],
          belowBarData: BarAreaData(
            show: true,
            colors: [primary.withOpacity(0.5)],
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: [fontColor.withOpacity(0.2)],
          ),
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
      minY: 0,
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 3,
          getTextStyles: (context, value) => const TextStyle(
            color: black,
            fontSize: 9,
          ),
          margin: 10,
          getTitles: (value) {
            return months![value.toInt()];
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: fontColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  Color generateRandomColor() {
    Random random = Random();
    // Pick a random number in the range [0.0, 1.0)
    double randomDouble = random.nextDouble();

    return Color((randomDouble * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
      decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.1),
              colors: [
                AppColor().colorBg2(),
                AppColor().colorBg2(),
              ],
              radius: 0.8,
            ),
      ),
      //  padding: EdgeInsets.symmetric(horizontal: ),
      child: _isNetworkAvail?Stack(
            children: [
              Container(
                height: 23.82.h,
                padding: EdgeInsets.only( left: 8.33.w,bottom: 10.87.h, right: 8.33.w),
                width: 100.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(homeFg),
                  fit: BoxFit.fill,
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    text(
                      "Current Leads",
                      textColor: Color(0xffffffff),
                      fontSize: 14.sp,
                      fontFamily: fontBold,
                    ),
                    Container(
                      child: Row(
                        children: [
                          isSwitched ? text(
                            "Online Mode",
                            textColor: Color(0xff13CE3F),
                            fontSize: 10.sp,
                            fontFamily: fontRegular,
                          ) : text(
                      "Offline Mode",
                      textColor: Colors.red,
                      fontSize: 10.sp,
                      fontFamily: fontRegular,
                    ),
                          SizedBox(
                            width: 3.05.w,
                          ),
                          Switch.adaptive(
                              activeColor: Colors.green,
                              value: isSwitched,
                              onChanged: (val){
                                setState(() {
                                  isSwitched=val;
                                });
                                  updateSellerStatus();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                 top: 10.87.h,left: 2.33.w,right: 2.33.w,
                ),
                child: Column(
                  children: [
                  //  getChart(),
                    firstHeader(),
                    secondHeader(),
                    thirdHeader(),
                    isSwitched?
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ServiceScreenDetails(id: item!.id.toString(),))
                          );
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
                                                          ?text(
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
                              item.itemList![0].activeStatus==PLACED?!loading?Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.44.w,vertical: 1.5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        updateOrder(
                                          item,
                                          CANCLED,
                                          updateOrderItemApi,
                                          item!.id,
                                          true,
                                          0,
                                        );
                                        //acceptStatus(item!.id, "2");
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
                                    InkWell(
                                      onTap: (){
                                        updateOrder(
                                          item,
                                          PROCESSED,
                                          updateOrderItemApi,
                                          item!.id,
                                          true,
                                          0,
                                        );
                                      },
                                      child: Container(
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
                                    ),
                                  ],
                                ),
                              ):Center(child: CircularProgressIndicator(),):SizedBox()

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
                      child: Center(child: text("No Order Available",fontSize: 14.sp,fontFamily: fontBold,textColor: Colors.black)),) : Container(
                      height: 30.h,
                      child: Center(child: text("You are offline",fontSize: 14.sp,fontFamily: fontBold,textColor: Colors.black)),),
                  ],
                ),
              ),
              scrollGettingData
                  ? Center(
                    child: Container(
                      height: 100.h,
                padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                child: Center(child: CircularProgressIndicator()),
              ),
                  )
                  : Container(),
            ],
      ):noInternet(context),
    ),
          ),
        ));
  }
  bool loading = false;
  Future<Null> acceptStatus(orderId,status) async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        setState((){
          loading =true;
        });
        CUR_USERID = await getPrefrence(Id);
        var parameter = {"order_id": orderId,  "accept_reject": status,};

        Response response =
        await post(acceptStatusApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        print(getdata);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        setState((){
          loading = false;
        });
        if (!error) {
          setSnackbar(msg.toString(),context);
         onRefresh();
        }

      } on TimeoutException catch (_) {
        setSnackbar("Something went wrong",context);

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

  Future updateSellerStatus() async{
    var request = http.MultipartRequest('POST', updateSellerStatusApi);
    request.fields.addAll({
      'open_close_status': isSwitched?"1":"0",
      'user_id': '$CUR_USERID'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = SellerStatusModel.fromJson(json.decode(str));
      if(jsonResponse.error == false){
        setSnackbar(jsonResponse.message!, context);
      }
      return SellerStatusModel.fromJson(json.decode(str));
    }
    else {
    return null;
    }

  }

  firstHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getOrderButton(),
        getBalanceButton(),
        getProductsButton(),
      ],
    );
  }

  getOrderButton() {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainOrderHistory()));
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "ORDER")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalorderCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBalanceButton() {
    return Expanded(
      flex: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(), //  WalletHistory(),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "BALANCE_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  CUR_CURRENCY + " " + CUR_BALANCE,
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getProductsButton() {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductList(
                flag: '',
              ),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.wallet_giftcard,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "PRODUCT_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalproductCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  secondHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getCustomerButton(),
        getRattingButton(),
      ],
    );
  }

  getRattingButton() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Icon(
                Icons.star_rounded,
                color: primary,
              ),
              Text(
                "Rating",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: grey,
                ),
              ),
              Text(
                RATTING + r" / " + NO_OFF_RATTING,
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  getCustomerButton() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Customers(),
            ),
          );
        },
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.group,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "CUSTOMER_LBL")!,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalcustCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================
//========================= Third Row Implimentation ===========================

  thirdHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getSoldOutProduct(),
        getLowStockProduct(),
      ],
    );
  }

  getSoldOutProduct() {
    return Expanded(
      flex: 2,
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  flag: "sold",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.not_interested,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "Sold Out Products")!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totalsoldOutCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLowStockProduct() {
    return Expanded(
      flex: 2,
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  flag: "low",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Icon(
                  Icons.offline_bolt,
                  color: primary,
                ),
                Text(
                  getTranslated(context, "Low Stock Products")!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  totallowStockCount ?? "",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
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
              selected: false,
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
  Future<void> updateOrder(
      var model,
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
          setState((){
            loading =true;
          });
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

          print(parameter);

          print("UPDATE ORDER PARAMETER ===== $parameter");
          print("UPDATE ORDER API ===== $updateOrderItemApi");
          apiBaseHelper.postAPICall(updateOrderItemApi, parameter).then(
                (getdata) async {
                  setState((){
                    loading =false;
                  });
              bool error = getdata["error"];
              String msg = getdata["message"];
              setSnackbar(msg,context);
              print("msg : $msg");
              if (!error) {
                onRefresh();
              } else {
                onRefresh();
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
          };
          print(parameter);
          if (start != null)
            parameter[START_DATE] = "${startDate.toLocal()}".split(' ')[0];
          if (end != null)
            parameter[END_DATE] = "${endDate.toLocal()}".split(' ')[0];
         /* if (activeStatus != null) {
            if (activeStatus == awaitingPayment) activeStatus = "awaiting";
            parameter[ActiveStatus] = activeStatus!;
          }*/

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
  Future<Null> getFid() async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(Id);

        var parameter = {"user_id": CUR_USERID};

        Response response =
        await post(getUserApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          var data = getdata["data"][0];
          App.localStorage.setString("firebaseUid", data['fuid']);
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something went wrong",context);

      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }

    return null;
  }
  Future<Null> updateFid(fid) async {
    await App.init();
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(Id);

        var parameter = {"user_id": CUR_USERID,  "fuid": fid,};

        Response response =
        await post(getUpdateApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          App.localStorage.setString("firebaseUid", fid.toString());
        }

      } on TimeoutException catch (_) {
        setSnackbar("Something went wrong",context);

      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;

        });
    }

    return null;
  }

  String  sellerEmail = "";
  String  sellerName = "";
  callChat() async {
    await App.init();
    try {
      UserCredential data =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: sellerEmail,
        password: "12345678",
      );
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: sellerName,
          id: data.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$sellerEmail',
          lastName: "",
        ),
      );
      updateFid( data.user!.uid);
    } catch (e) {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: sellerEmail,
        password: "12345678",
      );
      // App.localStorage.setString("firebaseUid", credential.user!.uid);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: sellerName,
          id: credential.user!.uid,
          imageUrl: 'https://i.pravatar.cc/300?u=$sellerEmail',
          lastName: "",
        ),
      );
      updateFid(credential.user!.uid);
      print(e.toString());
    }
  }
  Future<void> onRefresh() async{
    setState(() {
      activeStatus = "received";
      scrollLoadmore = true;
      scrollOffset = 0;
      orderList.clear();
    });
    getSallerDetail();
    await getOrder();
  }
}