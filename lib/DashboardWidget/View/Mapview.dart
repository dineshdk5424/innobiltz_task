import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:innobiltz/CommonWidget/SpinLoader.dart';
import 'package:innobiltz/DashboardWidget/View/Dashboardpage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:geocoding/geocoding.dart';

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

class MapviewScreen extends StatefulWidget {
  MapviewScreen({Key? key}) : super(key: key);

  @override
  State<MapviewScreen> createState() => _MapviewScreenState();
}

class _MapviewScreenState extends State<MapviewScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  var currentLocation = null;
  bool isLoading = false;
  var latitude;
  var longitude;
  var ulatitude;
  var ulongitude;
  var currentPostion;

  var userDetails;
  final LocalStorage storage = new LocalStorage('local_store');

  @override
  void initState() {
    this.setState(() {
      isLoading = true;
    });
    var result = storage.getItem('select_user');
    print(result);
    getCurrentLocation();
    getPatientAddress();
    this.setState(() {
      userDetails = result;
      ulatitude = double.parse(result['address']['geo']['lat']);
      ulongitude = double.parse(result['address']['geo']['lng']);
      isLoading = false;
    });
    super.initState();
  }

  getCurrentLocation() async {
    this.setState(() {
      isLoading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('POSITIONS::::::::::::::::${position}');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    this.setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      isLoading = false;
    });
    print(placemarks);
  }

  getPatientAddress() async {
    this.setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    this.setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    print(placemarks);
    setState(() {
      currentLocation = place;
      isLoading = false;
    });
    print(currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return new WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
          return true;
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.red,
                title: const Text('Location'),
              ),
            ),
            body: !isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            // height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            width: screenwidth,
                            // color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current Address:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "${currentLocation != null ? currentLocation.name : ''}"),
                                  isvalidElement(currentLocation)
                                      ? Text(
                                          currentLocation != null
                                              ? currentLocation.street
                                              : '' + ", " + currentLocation !=
                                                      null
                                                  ? currentLocation.subLocality
                                                  : '' +
                                                              ', ' +
                                                              currentLocation !=
                                                          null
                                                      ? currentLocation.locality
                                                      : '' +
                                                                  ' - ' +
                                                                  currentLocation !=
                                                              null
                                                          ? currentLocation
                                                              .postalCode
                                                          : '',
                                          softWrap: true,
                                        )
                                      : Text(''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Container(
                            // height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            width: screenwidth,
                            // color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TO:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userDetails['address']['suite'] +
                                        ", " +
                                        userDetails['address']['street'] +
                                        ', ' +
                                        userDetails['address']['city'] +
                                        ' - ' +
                                        userDetails['address']['zipcode'],
                                    softWrap: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenwidth * 0.03,
                          ),
                          Container(
                            height: screenHeight * 0.6,
                            child: GoogleMap(
                              myLocationButtonEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(11.563562, 74.568959),
                                zoom: 1.5,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId("source"),
                                  position: LatLng(
                                      isvalidElement(ulatitude)
                                          ? ulatitude
                                          : 11.563562,
                                      isvalidElement(ulongitude)
                                          ? ulongitude
                                          : 74.568959),
                                ),
                                Marker(
                                  markerId: MarkerId("destination"),
                                  position: LatLng(
                                      isvalidElement(latitude)
                                          ? latitude
                                          : 11.563562,
                                      isvalidElement(longitude)
                                          ? longitude
                                          : 74.568959),
                                ),
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SpinLoader()));
  }
}

isvalidElement(data) {
  return data != null;
}
