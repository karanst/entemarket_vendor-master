import 'package:ziberto_vendor/Helper/String.dart';
import 'package:intl/intl.dart';
import 'AttachmentModel.dart';
import 'OrderItemsModel.dart';

class Order_Model {
  String? id,
      name,
      mobile,
      latitude,
      longitude,
  sellerLat,sellerLng,
      delCharge,
      walBal,
      promo,
      promoDis,
      payMethod,
      total,
      subTotal,
      payable,
      address,
      taxAmt,
      taxPer,
      orderDate,
      dateTime,
      isCancleable,
      isReturnable,
      isAlrCancelled,
      isAlrReturned,
      rtnReqSubmitted,
      otp,
      // deliveryBoyId,
      invoice,
      delDate,
      delTime,
      driverAcceptReject,
      countryCode,activeStatus,drivername,driverfuid,driveremail,driverfcm,username,userfuid,useremail,userfcm_id;
  List<Attachment>? attachList = [];
  List<OrderItem>? itemList;
  List<String?>? listStatus = [];
  List<String?>? listDate = [];

  Order_Model({
    this.id,
    this.name,
    this.mobile,
    this.delCharge,
    this.walBal,
    this.promo,
    this.promoDis,
    this.payMethod,
    this.total,
    this.subTotal,
    this.payable,
    this.address,
    this.taxPer,
    this.taxAmt,
    this.orderDate,
    this.dateTime,
    this.itemList,
    this.listStatus,
    this.listDate,
    this.isReturnable,
    this.isCancleable,
    this.isAlrCancelled,
    this.isAlrReturned,
    this.rtnReqSubmitted,
    this.otp,
    this.invoice,
    this.latitude,
    this.longitude,
    this.sellerLat,
    this.sellerLng,
    this.delDate,
    this.delTime,
    this.activeStatus,
    // this.deliveryBoyId,
    this.countryCode,
    this.driverfcm,
    this.driverfuid,
    this.driveremail,
    this.drivername,
    this.username,
    this.userfuid,
    this.userfcm_id,
    this.useremail,
    this.driverAcceptReject
  });

  factory Order_Model.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderItem> itemList = [];
    var order = (parsedJson[OrderItemss] as List?);
    print("temp");
    print("order : $order");
    // if (order == null || order.isEmpty)
    //   return null;
    // else
    itemList = order!.map((data) => new OrderItem.fromJson(data)).toList();
    String date = parsedJson[DateAdded];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

    List<String?> lStatus = [];
    List<String?> lDate = [];

    return new Order_Model(
      id: parsedJson[Id],
      name: parsedJson[Username],
      mobile: parsedJson[Mobile],
      delCharge: parsedJson[DeliveryCharge],
      walBal: parsedJson[WalletBalance],
      promo: parsedJson[PromoCode],
      promoDis: parsedJson[PromoDiscount],
      payMethod: parsedJson[PaymentMethod],
      total: parsedJson[FinalTotal],
      subTotal: parsedJson[Total],
      payable: parsedJson[TotalPayable],
      address: parsedJson[Address],
      taxAmt: parsedJson[TotalTaxAmount],
      taxPer: parsedJson[TotalTaxPercent],
      dateTime: parsedJson[DateAdded],
      isCancleable: parsedJson[IsCancelable],
      isReturnable: parsedJson[IsReturnable],
      isAlrCancelled: parsedJson[IsAlreadyCancelled],
      isAlrReturned: parsedJson[IsAlreadyReturned],
      rtnReqSubmitted: parsedJson[ReturnRequestSubmitted],
      driverfcm: parsedJson['driverfcm'],
      driverfuid: parsedJson['driverfuid'],
      driveremail: parsedJson['driveremail'],
      drivername: parsedJson['drivername'],
      username: parsedJson['username'],
      userfuid: parsedJson['userfuid'],
      userfcm_id: parsedJson['userfcm_id'],
      useremail: parsedJson['useremail'],
      orderDate: date,
      itemList: itemList,
      listStatus: lStatus,
      listDate: lDate,
      otp: parsedJson[Otp],
      latitude: parsedJson[Latitude],
      longitude: parsedJson[Longitude],
      sellerLat: parsedJson["sellerlatitude"],
      sellerLng: parsedJson["sellerlogtitude"],
      countryCode: parsedJson[COUNTRY_CODE],
      driverAcceptReject: parsedJson["accept_reject_driver"],
      delDate: parsedJson[DeliveryDate] != null
          ? DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(parsedJson[DeliveryDate]))
          : '',
      delTime: parsedJson[DeliveryTime] != null ? parsedJson[DeliveryTime] : '',

      //deliveryBoyId: parsedJson[Delivery_Boy_Id]
    );
  }
}
