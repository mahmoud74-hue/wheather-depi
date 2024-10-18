import 'package:final_depi/components/weather_item.dart';
import 'package:final_depi/constants.dart';
import 'package:final_depi/views/detail_page.dart';
import 'package:final_depi/views/home/homecontroller/homecontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Homecontroller controller = Get.put(Homecontroller());
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  @override
  void initState() {
    controller.getCityName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: _constants.primaryColor,
                ),
              )
            : Container(
                width: size.width,
                height: size.height,
                padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                color: _constants.primaryColor.withOpacity(.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: size.height * .7,
                      decoration: BoxDecoration(
                        gradient: _constants.linearGradientBlue,
                        boxShadow: [
                          BoxShadow(
                            color: _constants.primaryColor.withOpacity(.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.thermostat,
                                size: 40,
                                color: Colors.white,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/pin.png",
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    controller.location.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _cityController.clear();
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                          controller:
                                              ModalScrollController.of(context),
                                          child: Container(
                                            height: size.height * .45,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 70,
                                                  child: Divider(
                                                    thickness: 3.5,
                                                    color:
                                                        _constants.primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  onChanged: (searchText) {
                                                    controller.fetchWeatherData(
                                                        searchText);
                                                  },
                                                  controller: _cityController,
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      color: _constants
                                                          .primaryColor,
                                                    ),
                                                    suffixIcon:
                                                        GestureDetector(
                                                      onTap: () =>
                                                          _cityController
                                                              .clear(),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: _constants
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    hintText:
                                                        "Search City e.g. Cairo",
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: _constants
                                                            .primaryColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white70),
                                  child: Image.asset(
                                    "assets/profile.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 160,
                            child: Image.asset(
                                "assets/${controller.weatherIcon.value}"),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.temperature.value.toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = _constants.shader,
                                  ),
                                ),
                              ),
                              Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = _constants.shader,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            controller.currentWeatherStatus.value,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            controller.currentDate.value,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Divider(
                              color: Colors.white70,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherItem(
                                  value: controller.windSpeed.value.toInt(),
                                  unit: ' km/h',
                                  imageUrl: 'assets/windspeed.png',
                                ),
                                WeatherItem(
                                  value: controller.humidity.value.toInt(),
                                  unit: '%',
                                  imageUrl: 'assets/humidity.png',
                                ),
                                WeatherItem(
                                  value: controller.cloud.value.toInt(),
                                  unit: '%',
                                  imageUrl: 'assets/cloud.png',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Today',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      dailyForecastWeather:
                                          controller.dailyWeatherForecast,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Forecasts",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: _constants.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 110,
                            child: listview(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  ListView listview() {
    return ListView.builder(
      itemCount: controller.hourlyWeatherForecast.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        String currentHour = currentTime.substring(0, 2);

        String forecastTime =
            controller.hourlyWeatherForecast[index]["time"].substring(11, 16);
        String forecastHour =
            controller.hourlyWeatherForecast[index]["time"].substring(11, 13);

        String forecastWeatherName =
            controller.hourlyWeatherForecast[index]["condition"]["text"];
        String forecastWeatherIcon =
            "${forecastWeatherName.replaceAll(" ", "").toLowerCase()}.png";

        String forecastTemperature =
            controller.hourlyWeatherForecast[index]["temp_c"].round().toString();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.only(right: 20),
          width: 65,
          decoration: BoxDecoration(
            color: currentHour == forecastHour
                ? Colors.white
                : _constants.primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: _constants.primaryColor.withOpacity(.2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                forecastTime,
                style: TextStyle(
                  fontSize: 17,
                  color: _constants.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Image.asset(
                "assets/$forecastWeatherIcon",
                width: 20,
              ),
              Text(
                forecastTemperature,
                style: TextStyle(
                  fontSize: 17,
                  color: _constants.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
