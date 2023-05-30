import 'dart:convert';
import 'dart:io';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:custom_dialog/custom_dialog.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:ziberto_vendor/Helper/ApiBaseHelper.dart';
import 'package:ziberto_vendor/Helper/Color.dart';
import 'package:ziberto_vendor/Helper/Constant.dart';
import 'package:ziberto_vendor/Helper/Session.dart';
import 'package:ziberto_vendor/Helper/String.dart';
import 'package:ziberto_vendor/Helper/images.dart';
import 'package:ziberto_vendor/Helper/myappbar.dart';
import 'package:ziberto_vendor/Model/getWithdrawelRequest/getWithdrawelmodel.dart';
import 'package:permission_handler/permission_handler.dart' as Per;
import "package:http/http.dart" as http;
import 'package:path/path.dart' as path;
bool _isLoading = true;
bool isLoadingmore = true;
int offset = 0;
int total = 0;
List<GetWithdrawelReq> tranList = [];
class AddMedia extends StatefulWidget {
  const AddMedia({Key? key}) : super(key: key);

  @override
  _AddMediaState createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  bool selected = false, enabled = false, edit = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isNetworkAvail = true;
  String? amount, msg;
  ScrollController controller = new ScrollController();
  TextEditingController? amtC, bankDetailC;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GetWithdrawelReq> tempList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor(AppColor().colorPrimaryDark());
    return Scaffold(
      backgroundColor: AppColor().colorBg1(),
      body: SafeArea(
        child: SingleChildScrollView(
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
            child: Column(
              children: [
                MyappBarView(
                  mytitle: "Add Media",
                ),
                SizedBox(height: 5.h,),
                logoImage!=null?Container(
                    width: 100.w,height:40.h ,
                    padding: EdgeInsets.all(5.w),
                    child: Image.file(logoImage!,fit: BoxFit.fill,)):SizedBox(),
                SizedBox(height: 5.h,),
                Center(
                  child:ScaleAnimatedWidget.tween(
                    enabled: enabled,
                    duration: Duration(milliseconds: 200),
                    scaleDisabled: 1.0,
                    scaleEnabled: 0.8,
                    child: NewButton(
                      selected: false,
                      width: 69.99.w,
                      textContent:  logoImage!=null?"Edit Photo":"Add Photo",
                      onPressed: ()async{
                        setState(() {
                          enabled = true;
                        });
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {
                          enabled = false;
                        });
                        requestPermission(context, 1);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 5.h,),
                logoImage!=null?Center(
                  child:ScaleAnimatedWidget.tween(
                    enabled: enabled,
                    duration: Duration(milliseconds: 200),
                    scaleDisabled: 1.0,
                    scaleEnabled: 0.8,
                    child: NewButton(
                      selected: edit,
                      width: 69.99.w,
                      textContent: "Upload Photo",
                      onPressed: ()async{
                        setState(() {
                          enabled = true;
                        });
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {
                          enabled = false;
                        });
                        setState(() {
                          edit = true;
                        });
                        submitSubscription();
                      },
                    ),
                  ),
                ):SizedBox(),
                SizedBox(height: 5.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  File? gstImage, logoImage, proofImage, addressImage, foodImage;
  Future getImage(ImgSource source, BuildContext context, int i) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      getCropImage(context, image, i);
    });
  }

  void getCropImage(BuildContext context, var image, int i) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      logoImage = croppedFile;
    });
  }
  void requestPermission(BuildContext context, i) async {
    if (await Per.Permission.camera.request().isGranted) {
      getImage(ImgSource.Both, context, i);
      return;
      // Either the permission was already granted before or the user just granted it.
    }
// You can request multiple permissions at once.
    Map<Per.Permission, Per.PermissionStatus> statuses = await [
      Per.Permission.camera,
      Per.Permission.storage,
    ].request();
    if (statuses[Per.Permission.camera] == PermissionStatus.granted) {
      getImage(ImgSource.Both, context, i);
    } else {
      if (statuses[Per.Permission.camera] == PermissionStatus.denied) {
        Per.openAppSettings();
        setSnackbar("Oops you just denied the permission", context);
      }else{
        getImage(ImgSource.Both, context, i);
      }


    }
  }
  Future<void> submitSubscription(
      ) async {
    await App.init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://entemarket.com/seller/app/v1/api/uplaod_image"),
    );
    request.files.add(
      http.MultipartFile(
        'product_image',
        logoImage!.readAsBytes().asStream(),
        logoImage!.lengthSync(),
        filename: path.basename(logoImage!.path),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    request.fields.addAll({
     "seller_id":prefs.getString(Id).toString(),
    });
    print({"seller_id":prefs.getString(Id).toString()});
    print("request: " + request.toString());
    var res = await request.send();
    print("This is response:" + res.toString());
    if (res.statusCode == 200) {
      setState(() {
        edit =false;
      });
      final respStr = await res.stream.bytesToString();
      print(respStr.toString());
      Map data = jsonDecode(respStr.toString());
      if(!data['error']){

        setState(() {
          setSnackbar(data['message'].toString(), context);
        });
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            content: Text(
              'Wait for Approval',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20.0,
              ),
            ),
            title: Text('Uploaded Successful!!'),
            firstColor: Color(0xFF3CCF57),

            secondColor: Colors.white,
            headerIcon: Icon(
              Icons.check_circle_outline,
              size: 120.0,
              color: Colors.white,
            ),
          ),
        );
      }else{
        setState(() {
          setSnackbar(data['message'].toString(), context);
        });
      }

    }
  }
}
