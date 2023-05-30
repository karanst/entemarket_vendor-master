
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';

class CustomerSupportFAQ extends StatefulWidget {
  String title;
  String description;
  // int i;
  CustomerSupportFAQ({
    Key? key,
    required this.title,
    required this.description,
    // required this.i
  }) : super(key: key);

  @override
  _CustomerSupportFAQState createState() => _CustomerSupportFAQState();
}

class _CustomerSupportFAQState extends State<CustomerSupportFAQ> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: 4.33.w,right: 4.33.w,bottom:1.87.h
          ),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              color: Color(0xFFF7F7F7)),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.title.toString(),
                    style: TextStyle(color: Color(0xFF060000), fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      _showContent = !_showContent;
                    });
                  },
                  child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.PrimaryDark,
                      ),
                      child: _showContent
                          ? Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20.0,
                            )
                          : Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.0,
                            ))),
            ],
          ),
        ),
        _showContent
            ? Container(
                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                width: MediaQuery.of(context).size.width,
                //margin: EdgeInsets.only(top: 0.0),
          margin: EdgeInsets.only(
              left: 4.33.w,right: 4.33.w,bottom:1.87.h
          ),
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 15.0, bottom: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Color(0xFFF7F7F7)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.description.toString(),
                    style: TextStyle(
                      color: Color(0xFF060000),
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
