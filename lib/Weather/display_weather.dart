import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'display_weather_view_model.dart';
import 'package:http/http.dart' as http;

class DisplayWeatherPage extends StatefulWidget {
  const DisplayWeatherPage({
    Key? key,
  }) : super(key: key);

  @override
  _DisplayWeatherPageState createState() => _DisplayWeatherPageState();
}

class _DisplayWeatherPageState extends State<DisplayWeatherPage> with DisplayWeatherPageViewModel {
  bool isLoading = true;

  String lat = '';
  String lon = '';

  List<DropdownMenuItem<dynamic>> weatherDisplayType = [];
  DisplayType? selectedWeatherDisplay;

  dynamic dataDisplay;

  @override
  void initState() {
    super.initState();
    weatherDisplayType = DisplayType.values.map((val) {
      return DropdownMenuItem(
        child: Text(val.toString().split('.')[1]),
        value: val,
      );
    }).toList();
    WidgetsBinding.instance!.addPostFrameCallback((_) => initData());
  }

  initData() async {
    http.Response response = await http.get(Uri.parse("http://api.openweathermap.org/geo/1.0/direct?q=Kuala Lumpur, MY&limit=5&appid=5456be4fa11f29f0829cb3c94d61e972"));
    if (response.statusCode == HttpStatus.ok) {
      var val = json.decode(response.body);

      val.first['local_names'] = null;
      lat = val.first['lat'].toString();
      lon = val.first['lon'].toString();
      print(val.first);
      print(lat);
      setState(() {
        isLoading = false;
      });
      // getCurWeather();
    }
  }

  getCurWeather() async {
    // call API get current weather
    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=5456be4fa11f29f0829cb3c94d61e972"));
    if (response.statusCode == HttpStatus.ok) {
      var val = json.decode(response.body);
      dataDisplay = val;
      setState(() {});
    }
  }

  rowWidget(text1, text2){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text1.toString()),
          Text(text2.toString()),
        ],
      ),
    );
  }

  currentWeatherContainer(){
    return Column(
      children: [
        rowWidget('Name', dataDisplay['name']),
        rowWidget('Weather', dataDisplay['weather'][0]['main']),
        rowWidget('Temperature', dataDisplay['main']['temp']),
        rowWidget('Temperature Min', dataDisplay['main']['temp_min']),
        rowWidget('Temperature Max', dataDisplay['main']['temp_max']),
        rowWidget('Humidity', dataDisplay['main']['humidity']),
      ],
    );
  }

  view(){
    if(selectedWeatherDisplay != null && dataDisplay != null){
      switch(selectedWeatherDisplay!){
        case DisplayType.CurrentWeather:
          return currentWeatherContainer();
          break;
      }
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? Container()
            : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  hint: Text(
                    'Display Type',
                  ),
                  value: selectedWeatherDisplay,
                  underline: Container(),
                  onChanged: (dynamic newValue) {
                    selectedWeatherDisplay = newValue;
                    getCurWeather();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  items: weatherDisplayType,
                ),
                const SizedBox(height: 20,),
                view(),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum DisplayType{
  CurrentWeather,
}