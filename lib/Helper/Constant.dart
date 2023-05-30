import 'package:shared_preferences/shared_preferences.dart';

final String appName = 'EnteMarket Vendor';

final String packageName = 'com.enter_market_vendor';

final String iosPackage = 'com.enter_market_vendor';

final String baseUrl = 'https://entemarket.com/seller/app/v1/api/';

final String jwtKey = "f78d95e500c7ef84ee99d69d9651ff7a229979a2";
String razorPayKey="rzp_test_UUBtmcArqOLqIY";
String razorPaySecret="NTW3MUbXOtcwUrz5a4YCshqk";
//timeout limit
final int timeOut = 50;
const int perPage = 10;
const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontSemibold = 'Semibold';
const fontBold = 'Bold';
class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
const String BANK_DETAIL = 'Bank Details:\n' +
    'Account No :123XXXXX\n' +
    'IFSC Code: 123XXX \n' +
    'Name: Abc xyz';
