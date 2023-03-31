import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    LocationPermission permission = await geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
      debugPrint('denied permission');
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied permission
      debugPrint('permanently denied permission');
      return;
    }

    Position position = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ));
    setState(() {
      _currentPosition = position;
    });
    if (_currentPosition?.latitude != null) {
      var lat = _currentPosition?.latitude;
      var lon = _currentPosition?.longitude;
      locationName = await getLocationName(lat!, lon!);
      // debugPrint(locationName);
      Fluttertoast.showToast(
        msg: locationName,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
      );
    }
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks[0];
    String subLocality = placemark.subLocality ?? '';
    String subFace = placemark.subThoroughfare ?? '';
    String fare = placemark.thoroughfare ?? '';
    String isoCode = placemark.isoCountryCode ?? '';
    String postal = placemark.postalCode ?? '';
    String street = placemark.street ?? '';
    String adminArea = placemark.subAdministrativeArea ?? '';
    String name = placemark.name ?? '';
    String locality = placemark.locality ?? '';
    String administrativeArea = placemark.administrativeArea ?? '';
    String country = placemark.country ?? '';
    return "Sub-face: $subFace,\n "
        "Street: $street,\n "
        "Name: $name,\n "
        "Fare: $fare,\n "
        "Sub-locality: $subLocality,\n "
        "Locality: $locality,\n "
        "Sub-admin Area: $adminArea\n "
        "Admin Area: $administrativeArea,\n "
        "Country: $country,\n "
        "Postal Code: $postal,\n "
        "ISO Code:  $isoCode,\n ";
  }

  String locationName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
                'Accuracy: ${_currentPosition?.accuracy == null ? "Null" : _currentPosition!.accuracy.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Altitude: ${_currentPosition?.altitude == null ? "Null" : _currentPosition!.altitude.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Floor: ${_currentPosition?.floor == null ? "Null" : _currentPosition!.floor.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Heading: ${_currentPosition?.heading == null ? "Null" : _currentPosition!.heading.toString()}'),
            const SizedBox(height: 12),
            Text(
                'isMocked: ${_currentPosition?.isMocked == null ? "Null" : _currentPosition!.isMocked.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Latitude: ${_currentPosition?.latitude == null ? "Null" : _currentPosition!.latitude.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Longitude: ${_currentPosition?.longitude == null ? "Null" : _currentPosition!.longitude.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Speed: ${_currentPosition?.speed == null ? "Null" : _currentPosition!.speed.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Speed accuracy: ${_currentPosition?.speedAccuracy == null ? "Null" : _currentPosition!.speedAccuracy.toString()}'),
            const SizedBox(height: 12),
            Text(
                'Timestamp: ${_currentPosition?.timestamp == null ? "Null" : _currentPosition!.timestamp.toString()}'),
            const SizedBox(height: 12),
            Text(
              locationName,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                _getCurrentLocation();
              },
              child: const Text('Get'),
            )
          ],
        ),
      ),
    );
  }
}
