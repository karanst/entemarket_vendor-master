import 'package:animated_widgets/animated_widgets.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/myappbar.dart';
import 'package:ziberto_vendor/NewScreen/customer_support_faq.dart';

class MainCustomerSupport extends StatefulWidget {
  const MainCustomerSupport({Key? key}) : super(key: key);

  @override
  _MainCustomerSupportState createState() => _MainCustomerSupportState();
}

class _MainCustomerSupportState extends State<MainCustomerSupport> {
  bool selected = false, enabled = false, edit = false;
  TextEditingController desController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
            child: Container(
              child: Column(
                children: [
                  MyappBarView(
                    mytitle: "Customer support",
                  ),
                  SizedBox(height: 15,),
                  Container(
                    margin: EdgeInsets.only(
                        left: 4.33.w,right: 4.33.w,bottom:0.87.h
                    ),
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 25.0, bottom: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFFFF7F7F7)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Business Support",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF060000),
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "Business@InteMarket.com",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColor.PrimaryDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "General Support",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFFF060000),
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7.0),
                                child: Text(
                                  "Support@InteMarket.com",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColor.PrimaryDark),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
// new Section
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/need_help_bg.png'))),
                    width: mysize.width * 0.9,
                    child: SizedBox(
                        width: mysize.width * 0.9,
                        height: mysize.height * 0.25,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'You Can have Live Whats \napp Chat With Our Support Team',
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.0,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        )),
                  ),
                  // my all Faq
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, int i) {
                          return CustomerSupportFAQ(
                            title: "How can I manage my Orders?",
                            description:
                                "You can manage your Orders in the App, in My Account page Orders tab",
                          );
                        }),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: 4.33.w,right: 4.33.w,bottom:1.87.h
                      ),
                      child: text(
                          "If you Can't find a solution You can Write About Your Problem and Send to us",
                          textColor: AppColor().colorTextPrimary(),
                          fontSize: 8.5.sp,
                          fontFamily: fontMedium,
                          isCentered: false,
                          maxLine: 3)),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Container(
                    height: 15.46.h,
                    margin: EdgeInsets.only(
                        left: 4.33.w,right: 4.33.w,bottom:1.87.h
                    ),
                    child: TextFormField(
                      cursorColor: Colors.red,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      minLines: 5,
                      maxLines: 5,
                      controller: desController,
                      style: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      inputFormatters: [],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(),
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Describe Your Problem here',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),

                        helperText: '',
                        counterText: '',
                        fillColor: AppColor().colorEdit(),
                        enabled: true,
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(), width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.02.h,
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
      ),
    );
  }
}
