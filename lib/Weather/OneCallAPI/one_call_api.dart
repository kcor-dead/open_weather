import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OneCallAPIPage extends StatefulWidget {
  const OneCallAPIPage({
    Key? key,
  }) : super(key: key);

  @override
  _OneCallAPIPageState createState() => _OneCallAPIPageState();
}

class _OneCallAPIPageState extends State<OneCallAPIPage> {
  bool isLoading = true;

  String lat = '';
  String lon = '';

  // List<DropdownMenuItem<dynamic>> weatherDisplayType = [];
  // DisplayType? selectedWeatherDisplay;

  dynamic dataDisplay;

  dynamic weather = [];
  dynamic hour = [];
  dynamic day = [];

  @override
  void initState() {
    super.initState();
    // weatherDisplayType = DisplayType.values.map((val) {
    //   return DropdownMenuItem(
    //     child: Text(val.toString().split('.')[1]),
    //     value: val,
    //   );
    // }).toList();
    WidgetsBinding.instance!.addPostFrameCallback((_) => initData());
  }

  initData() async {
    //get kuala lumpur lat lon
    http.Response response = await http.get(Uri.parse("http://api.openweathermap.org/geo/1.0/direct?q=Kuala Lumpur, MY&limit=5&appid=5456be4fa11f29f0829cb3c94d61e972"));
    if (response.statusCode == HttpStatus.ok) {
      var val = json.decode(response.body);

      val.first['local_names'] = null;
      lat = val.first['lat'].toString();
      lon = val.first['lon'].toString();
      // print(val.first);
      // print(lat);
      http.Response response2 = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=5456be4fa11f29f0829cb3c94d61e972"));
      var val2 = json.decode(response2.body);
      val2['local_names'] = null;
      print(val2['hourly']);
      weather = val2['current']['weather'];
      hour = val2['hourly'];
      day = val2['daily'];
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

  getHourlyWeather() async {
    // call API get hourly weather
    print('esrt');
    http.Response response = await http.get(Uri.parse("https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=$lat&lon=$lon&appid=5456be4fa11f29f0829cb3c94d61e972"));
    var val = json.decode(response.body);
    print(val);
    if (response.statusCode == HttpStatus.ok) {
      var val = json.decode(response.body);
      dataDisplay = val;
      print(val);
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

  hourRow(element){
    var tmp = DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
    String display = tmp.year.toString() + '/' + tmp.month.toString() + '/' + tmp.day.toString() + ' ' + tmp.hour.toString() + ':' + tmp.minute.toString().padLeft(2,'0') + ':' + tmp.second.toString().padLeft(2,'0');
    return Column(
      children: [
        rowWidget(display,element['temp']),
        Divider(),
      ],
    );
  }

  dayRow(element){
    var tmp = DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
    String display = tmp.year.toString() + '/' + tmp.month.toString() + '/' + tmp.day.toString() + ' ' + tmp.hour.toString() + ':' + tmp.minute.toString().padLeft(2,'0') + ':' + tmp.second.toString().padLeft(2,'0');
    return Column(
      children: [
        rowWidget(display,''),
        rowWidget('day',element['temp']['day']),
        rowWidget('night',element['temp']['night']),
        Divider(),
      ],
    );
  }

  view(){
    // if(selectedWeatherDisplay != null && dataDisplay != null){
    //   switch(selectedWeatherDisplay!){
    //     case DisplayType.CurrentWeather:
    //       return currentWeatherContainer();
    //       break;
    //
    //     case DisplayType.HourlyWeather:
    //       return Container();
    //       break;
    //   }
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('hourly'),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black54),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for(var element in hour)
                  hourRow(element),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text('daily'),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black54),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for(var element in day)
                  dayRow(element),
              ],
            ),
          ),
        ),
      ],
    );
    return Container();
  }

  getWeather(){
    // if(selectedWeatherDisplay != null){
    //   switch(selectedWeatherDisplay!){
    //     case DisplayType.CurrentWeather:
    //       getCurWeather();
    //       break;
    //   }
    //   switch(selectedWeatherDisplay!){
    //     case DisplayType.HourlyWeather:
    //       getHourlyWeather();
    //       break;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Normal Weather APIs'),
      ),
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
                // DropdownButton(
                //   isExpanded: true,
                //   isDense: true,
                //   hint: Text(
                //     'Display Type',
                //   ),
                //   value: selectedWeatherDisplay,
                //   underline: Container(),
                //   onChanged: (dynamic newValue) {
                //     selectedWeatherDisplay = newValue;
                //     getWeather();
                //     if (mounted) {
                //       setState(() {});
                //     }
                //   },
                //   items: weatherDisplayType,
                // ),
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
  HourlyWeather,
}