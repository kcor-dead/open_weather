import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class WeatherWidgetPage extends StatefulWidget {
  const WeatherWidgetPage({
    Key? key,
  }) : super(key: key);

  @override
  _WeatherWidgetPageState createState() => _WeatherWidgetPageState();
}

class _WeatherWidgetPageState extends State<WeatherWidgetPage> {
  bool isLoading = true;
  late InAppWebViewController _webViewController;

  final html = '''<!DOCTYPE html>
  <html>
  <body>
  <div id="openweathermap-widget-11"></div>
  <script src='//openweathermap.org/themes/openweathermap/assets/vendor/owm/js/d3.min.js'></script><script>window.myWidgetParam ? window.myWidgetParam : window.myWidgetParam = [];  window.myWidgetParam.push({id: 11,cityid: '1733046',appid: '5456be4fa11f29f0829cb3c94d61e972',units: 'metric',containerid: 'openweathermap-widget-11',  });  (function() {var script = document.createElement('script');script.async = true;script.charset = "utf-8";script.src = "//openweathermap.org/themes/openweathermap/assets/vendor/owm/js/weather-widget-generator.js";var s = document.getElementsByTagName('script')[0];s.parentNode.insertBefore(script, s);  })();</script>
  </body>
  </html>
  ''';
final js = '''
  <script src='//openweathermap.org/themes/openweathermap/assets/vendor/owm/js/d3.min.js'></script><script>window.myWidgetParam ? window.myWidgetParam : window.myWidgetParam = [];  window.myWidgetParam.push({id: 11,cityid: '1733046',appid: '5456be4fa11f29f0829cb3c94d61e972',units: 'metric',containerid: 'openweathermap-widget-11',  });  (function() {var script = document.createElement('script');script.async = true;script.charset = "utf-8";script.src = "//openweathermap.org/themes/openweathermap/assets/vendor/owm/js/weather-widget-generator.js";var s = document.getElementsByTagName('script')[0];s.parentNode.insertBefore(script, s);  })();</script>
  ''';

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((_) => initData());
  }

  loadLocalFile() async {
    final url = Uri.dataFromString(html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
    // final urlJs = Uri.dataFromString(js,
    //   mimeType: 'text/javascript',
    //   // encoding: Encoding.getByName('utf-8'),
    // );
    _webViewController.loadUrl(urlRequest: URLRequest(url: url));
    // _webViewController.injectJavascriptFileFromUrl(urlFile: urlJs);
  }

  view(){
    return InAppWebView(
      // initialUrl: getData,
      // initialUrlRequest: URLRequest(url: Uri.parse(getData)),
      // initialData: InAppWebViewInitialData(data: html),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
//                        debuggingEnabled: true,
            supportZoom: true,
            // useOnDownloadStart: widget.download,
          )),
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
        loadLocalFile();
      },
    );
  }

  getWeather(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Widget'),
      ),
      body: SafeArea(
        bottom: false,
        child: view(),
      ),
    );
  }
}
