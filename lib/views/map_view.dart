import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:rider_app/res/constants/conts.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'dart:ui' as ui;

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LatLng? currentPosition = null;

  static const LatLng _latLngDelhi = LatLng(30.7333, 76.7794);
  static const LatLng _latLngNoida = LatLng(30.3752, 76.7821);

  double _heading = 0.0;


  Map<PolylineId , Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    getlocation().then((_) =>
    {
      getPolylinePoints().then((coordinates) =>
      {
        print("cordinates: $coordinates"),
        generatePolyLinesFromPoints(coordinates),
      }),
    },
    );
    _listenToSensorData();

  }

  void _listenToSensorData() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Get orientation using accelerometer data
      double x = event.x;
      double y = event.y;
      double z = event.z;
      // Calculate orientation
      double orientation = -1 * atan2(x, sqrt(y * y + z * z));
      setState(() {
        _heading = orientation * (360); // Convert radians to degrees
      });
    });
  }

  void addCustomIcon() async {
    final ByteData data = await rootBundle.load("assets/images/car.png");
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: 80, targetWidth: 80); // Adjust the size as needed
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);

    if (resizedData != null) {
      final Uint8List resizedBytes = resizedData.buffer.asUint8List();
      final BitmapDescriptor icon = BitmapDescriptor.fromBytes(resizedBytes);

      setState(() {
        markerIcon = icon;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(
        child: Text("Fetching Your Current Location..."),
      )
          : GoogleMap(
        onMapCreated: ((GoogleMapController controller) =>
            _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(target: _latLngDelhi, zoom: 15),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"),
            icon: markerIcon,
            position: currentPosition!,
            rotation: _heading,
          ),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _latLngDelhi,
          ),
          Marker(
            markerId: MarkerId("_destinationLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _latLngNoida,
          ),
        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  Future<void> _cameratopostion(LatLng position) async{
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: position , zoom:  15);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition),
    );



  }

  Future<void> getlocation() async{
    bool _serviceEnabled ;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null &&
      currentLocation.longitude != null){
        setState(() {
          currentPosition = LatLng(currentLocation.latitude! , currentLocation.longitude!);
          print(currentPosition);
          _cameratopostion(currentPosition!);
        });
      }
    });
  }
  Future<List<LatLng>> getPolylinePoints() async{
    List<LatLng> polylineCoordinates = [] ;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY, PointLatLng(_latLngDelhi.latitude, _latLngDelhi.longitude),
        PointLatLng(_latLngNoida.latitude, _latLngNoida.longitude) , travelMode: TravelMode.driving);

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude)); // Fix: Use point.longitude instead of point.latitude
      });
    }
    else{
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLinesFromPoints(List<LatLng> polylinesCoordinates ) async{
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue, // Update color as needed
        points:  polylinesCoordinates,
        width: 4);

    setState(() {
      polylines[id] = polyline ;
    });
  }
 }
