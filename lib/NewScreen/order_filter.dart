
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Session.dart';

enum filterType { pending, payment, receivedPayment }
enum filterTime { Days30, Weeks3, Months6 }

class Oredrfilter extends StatefulWidget {
  Oredrfilter({Key? key,required this.onResult}) : super(key: key);
  final ValueChanged onResult;
  @override
  _OredrfilterState createState() => _OredrfilterState();
}

class _OredrfilterState extends State<Oredrfilter> {
  filterType? myfilterType;
  filterTime? myfilterTime;
  bool selected = false, enabled = false, edit = false;
  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: mysize.height * 0.1,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.repeated,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [MyColor.primary, MyColor.primaryLight],
                stops: [
                  0.4,
                  1.8,
                ],
              ),
            ),
            child: ListTile(
              title: Text(
                "Apply Filter",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              trailing: IconButton(
                onPressed: (){
                  Map  data = {
                    "type":"all",
                    "date":"all",
                  };
                  widget.onResult(data);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close_outlined,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                Radio(
                  value: filterType.pending,
                  groupValue: myfilterType,
                  onChanged: (filterType? value) async {
                    setState(() {
                      myfilterType = value!;
                    });
                  },
                ),
                Text('Pending Order'),
                // new
                Radio(
                  value: filterType.payment,
                  groupValue: myfilterType,
                  onChanged: (filterType? value) async {
                    setState(() {
                      myfilterType = value!;
                    });
                  },
                ),
                Text('All Order'),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Radio(
                  value: filterType.receivedPayment,
                  groupValue: myfilterType,
                  onChanged: (filterType? value) async {
                    setState(() {
                      myfilterType = value!;
                    });
                  },
                ),
                Text('Delivered Payment'),
              ],
            ),
          ),
          // new
          Divider(),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: mysize.width / 25),
              child: Text(
                'Order Time Filter',
                style: TextStyle(fontWeight: FontWeight.w800),
              )),
          // new
          Container(
            child: Row(
              children: [
                Radio(
                  value: filterTime.Days30,
                  groupValue: myfilterTime,
                  onChanged: (filterTime? value) async {
                    setState(() {
                      myfilterTime = value!;
                    });
                  },
                ),
                Text('Today'),
                //new
                Radio(
                  value: filterTime.Weeks3,
                  groupValue: myfilterTime,
                  onChanged: (filterTime? value) async {
                    setState(() {
                      myfilterTime = value!;
                    });
                  },
                ),
                Text('Weekly'),
              ],
            ),
          ),
          // new
          Row(
            children: [
              Radio(
                value: filterTime.Months6,
                groupValue: myfilterTime,
                onChanged: (filterTime? value) async {
                  setState(() {
                    myfilterTime = value!;
                  });
                },
              ),
              Text('Monthly'),
            ],
          ),
          SizedBox(
            height: 6.05.h,
          ),
          Center(
            child:ScaleAnimatedWidget.tween(
              enabled: enabled,
              duration: Duration(milliseconds: 200),
              scaleDisabled: 1.0,
              scaleEnabled: 0.8,
              child: NewButton(
                selected: false,
                width: 49.99.w,
                textContent: "Apply",
                onPressed: ()async{
                  setState(() {
                    enabled = true;
                  });
                  await Future.delayed(Duration(milliseconds: 200));
                  setState(() {
                    enabled = false;
                  });
                  Map data = {
                  };
                  if(myfilterType == filterType.pending){
                      data['type'] = "shipped";
                  }else if(myfilterType == filterType.payment){
                    data['type'] = "all";
                  }else{
                    data['type'] = "delivered";
                  }
                  if(myfilterTime == filterTime.Days30){
                    data['date'] = "today";
                  }else if(myfilterTime == filterTime.Weeks3){
                    data['date'] = "weekly";
                  }else{
                    data['date'] = "monthly";
                  }
                  widget.onResult(data);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          //new
          // Container(
          //   margin: EdgeInsets.only(left: mysize.width / 25),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Select A Date Range :",
          //         style: TextStyle(fontWeight: FontWeight.w800),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
