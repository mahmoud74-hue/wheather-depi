import 'dart:convert';
import 'package:final_depi/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Homecontroller extends GetxController {
  // Reactive variables
  var location = ''.obs;
  var weatherIcon = ''.obs;
  var temperature = 0.obs;
  var windSpeed = 0.obs;
  var humidity = 0.obs;
  var cloud = 0.obs;
  var currentDate = ''.obs;
  var currentWeatherStatus = ''.obs;
  var hourlyWeatherForecast = [].obs;
  var dailyWeatherForecast = [].obs;
  var _isLoading = true.obs;
    static String apiKey = kapi;
  String searchWeatherApi =
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  // Method to get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    // Get the current position
    return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  }

  // Method to get city name and fetch weather data
  Future<void> getCityName() async {
    try {
      Position position = await _getCurrentLocation();
      location.value = "${position.latitude},${position.longitude}";
      await fetchWeatherData(location.value);
    } catch (e) {
      print(e);
    }
  }

  // Method to fetch weather data
  Future<void> fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherApi + searchText));
      final weatherData =
          Map<String, dynamic>.from(jsonDecode(searchResult.body) ?? {});

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      // Update the reactive variables directly
      location.value = getShortLocationName(locationData["name"]);

      var parsedDate = DateTime.parse(locationData["localtime"].substring(0, 10));
      var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
      currentDate.value = newDate;

      currentWeatherStatus.value = currentWeather["condition"]["text"];
      weatherIcon.value = "${currentWeatherStatus.value.replaceAll(' ', '').toLowerCase()}.png";
      temperature.value = currentWeather["temp_c"].toInt();
      windSpeed.value = currentWeather["wind_kph"].toInt();
      humidity.value = currentWeather["humidity"].toInt();
      cloud.value = currentWeather["cloud"].toInt();

      dailyWeatherForecast.value = weatherData["forecast"]["forecastday"];
      hourlyWeatherForecast.value = dailyWeatherForecast[0]["hour"];
      _isLoading.value = false;
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  // Utility method to get short location name
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");
    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }
}
