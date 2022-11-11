// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_application/location.dart';
import 'package:weather_application/weather.dart';
import 'package:weather_application/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherService weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    getWeather();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  void getWeather() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      return;
    }

    await weatherService.getWeatherData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen(weatherService: weatherService);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitRipple(
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
