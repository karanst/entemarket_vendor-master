
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/images.dart';

import 'bottom_bar.dart';

class OpenYourStore extends StatefulWidget {
  const OpenYourStore({Key? key}) : super(key: key);

  @override
  State<OpenYourStore> createState() => _OpenYourStoreState();
}

class _OpenYourStoreState extends State<OpenYourStore> {
  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                            "Store Opening /Closing Time",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.w),
                  alignment: Alignment.center,
                  width: mysize.width,
                  child: Card(
                    child: Column(
                      children: [
                        // Spacer(),
                        showOpenCloseTextView(title: "Store Opening Time"),
                        showOpenCloseTextView(title: "Store Closing Time "),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Container showOpenCloseTextView({title}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "10:00 AM",
              style: TextStyle(
                  color: MyColor.primary, fontWeight: FontWeight.w700),
            ),
          ),
          Spacer(),
          Container(
              decoration: BoxDecoration(
                  color: MyColor.primary,
                  borderRadius: BorderRadius.circular(7)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Change",
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              )),
          Spacer(),
        ],
      ),
    );
  }
}
