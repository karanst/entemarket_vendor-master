
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/images.dart';

import 'Constant.dart';
import 'Session.dart';

class MyappBarView extends StatelessWidget {
  String mytitle;
  MyappBarView({Key? key, required this.mytitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                // "Payment",
                mytitle,
                textColor: Color(0xffffffff),
                fontSize: 14.sp,
                fontFamily: fontMedium,
                isCentered: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
