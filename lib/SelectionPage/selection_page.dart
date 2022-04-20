import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_weather/Weather/OneCallAPI/one_call_api.dart';
import 'package:open_weather/Weather/WebWidget/web_widget.dart';
import 'package:open_weather/Weather/display_weather.dart';
import 'package:http/http.dart' as http;

class SelectionPage extends StatefulWidget {
  const SelectionPage({
    Key? key,
  }) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: (){
                        //const WeatherWidgetPage()
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const DisplayWeatherPage()),
                        );
                      },
                      child: Text('Weather API'),
                    ),
                    // ElevatedButton(
                    //   onPressed: (){
                    //     //const WeatherWidgetPage()
                    //     Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => const WeatherWidgetPage()),
                    //     );
                    //   },
                    //   child: Text('weather widget'),
                    // ),
                    ElevatedButton(
                      onPressed: (){
                        //const WeatherWidgetPage()
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const OneCallAPIPage()),
                        );
                      },
                      child: Text('One Call API'),
                    ),
                    const SizedBox(height: 20,),

                  ],
                ),
              ),
            ],
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