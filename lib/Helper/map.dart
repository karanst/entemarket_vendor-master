import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:ziberto_vendor/Helper/Color.dart';
const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;


class MapPage extends StatefulWidget {

  LatLng? SOURCE_LOCATION;
  LatLng? DEST_LOCATION;
  String pick,dest;
  MapPage({ this.SOURCE_LOCATION, this.DEST_LOCATION,this.pick="",this.dest="",});

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  //todo change google map api
  // String googleAPIKey = "AIzaSyAzWKOX71IubaSG0BhDPsPermCzIuZaOHs";
  String googleAPIKey = "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0";
  // for my custom icons
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? driverIcon;
  BitmapDescriptor? destinationIcon;
  LatLng? SOURCE_LOCATION;
  LatLng? DEST_LOCATION;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late LatLng latLng;


  double driveLat=0,driveLng=0;
  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(driveLat, driveLng),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(driveLat,
          driveLng);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'drivePin');
      _markers.add(Marker(
          markerId: MarkerId('drivePin'),
          position: pinPosition, // updated position
          icon: driverIcon!
      ));
    });
  }
  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/driving_pin.png');


    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/destination_map_marker.png');
    setState(() {
      SOURCE_LOCATION = widget.SOURCE_LOCATION;
      DEST_LOCATION = widget.DEST_LOCATION;
      setPolylines();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: widget.SOURCE_LOCATION!);
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated);
  }

  void onMapCreated(GoogleMapController controller) async{
   // controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    var nLat, nLon, sLat, sLon;
    SOURCE_LOCATION = widget.SOURCE_LOCATION;
    DEST_LOCATION = widget.DEST_LOCATION;
    if (DEST_LOCATION!.latitude <= SOURCE_LOCATION!.latitude) {
      sLat = DEST_LOCATION!.latitude;
      nLat = SOURCE_LOCATION!.latitude;
    } else {
      sLat = SOURCE_LOCATION!.latitude;
      nLat = DEST_LOCATION!.latitude;
    }
    if (DEST_LOCATION!.longitude <= SOURCE_LOCATION!.longitude) {
      sLon = DEST_LOCATION!.longitude;
      nLon = SOURCE_LOCATION!.longitude;
    } else {
      sLon = SOURCE_LOCATION!.longitude;
      nLon = DEST_LOCATION!.longitude;
    }
    LatLngBounds bound =
    LatLngBounds(southwest: LatLng(sLat, sLon), northeast: LatLng(nLat, nLon));
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 150);
    controller.animateCamera(u2).then((void v) {});
    setMapPins();
  }

  void setMapPins() async{
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION!,
          infoWindow: InfoWindow(
              title: "Pickup Location",
            snippet: widget.pick,
          ),
          icon: sourceIcon!));

      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION!,
          infoWindow: InfoWindow(
              title: "Destination Location",
            snippet: widget.dest,
          ),
          icon: destinationIcon!));
    });

  }

  setPolylines() async {
    print("started >>>>>>>>>>>>>>>>..");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(SOURCE_LOCATION!.latitude, SOURCE_LOCATION!.longitude),
      PointLatLng(DEST_LOCATION!.latitude, DEST_LOCATION!.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true
    );
    print("${result.points} >>>>>>>>>>>>>>>>..");
    print("$SOURCE_LOCATION >>>>>>>>>>>>>>>>..");
    print("$DEST_LOCATION >>>>>>>>>>>>>>>>..");
    print(result.errorMessage);
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }else{
      print("Failed");
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
        width: 5,
          polylineId: PolylineId("poly"),
          color: MyColor.primary,
          points: polylineCoordinates);
      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}