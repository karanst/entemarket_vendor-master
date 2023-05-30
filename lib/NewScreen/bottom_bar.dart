import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/NewScreen/notification_screen.dart';
import 'package:ziberto_vendor/NewScreen/profile_screen.dart';
import '../Helper/PushNotificationService.dart';
import 'home_screen.dart';
import 'main_order_history.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> tabList = [HomeScreen(), NotificationScreen(), ProfileScreen()];
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pushNotificationService = PushNotificationService(context: context);
    pushNotificationService.initialise();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: AppColor().colorBg2(),
        body: HomeScreen(),
        bottomNavigationBar: Container(
          height: 11.00.h,
          decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                tabItem(context, 0, home, "Home"),
                tabItem(context, 1, history, "Order History"),
                tabItem(context, 2, notification, "Notification"),
                tabItem(context, 3, profile, "My Account"),
              ],
            ),
          ),
        ),
      ),
    );
  }
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    print("thtghtf");
    DateTime now =  DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime =  now;
      setSnackbar("Press back again to exit",context);
      return Future.value(false);
    }
    exit(1);
    return Future.value(true);
  }

  Widget tabItem(BuildContext context, var pos, var icon, String title) {
    return GestureDetector(
      onTap: () {
        if(pos==0){
          setState(() {
            selectedIndex = pos;
          });
        }else{
          if (pos == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainOrderHistory()));
          }
          if (pos == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          }
          if (pos == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }
        }


      },
      child: Container(
        width: 18.63.w,
        height: 6.79.h,
        alignment: Alignment.center,
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 6.94.w,
              height: 3.80.h,
              color: selectedIndex == pos
                  ? AppColor().colorBottom()
                  : Color(0xff757575),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: selectedIndex == pos
                      ? AppColor().colorBottom()
                      : Color(0xff757575),
                  fontFamily: fontRegular,
                  fontSize: 8.sp),
            ),
          ],
        ),
      ),
    );
  }
}
