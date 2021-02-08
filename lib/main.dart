import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  //static const toast = const MethodChannel('samples.flutter.dev/toast');
  String _batteryLevel = 'Unknown battery level.';
  String getToastMessage = "Didn't get any message";

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      ///invoke method
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getToastMessage() async{
    String toastMessage;
    try{
      final String message = await platform.invokeMethod("getToast");
      toastMessage = '$message';
    } on PlatformException catch(e){
      toastMessage = "Failed to get toast Message: '${e.message}'.";
    }
    setState(() {
      getToastMessage = toastMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),

            ElevatedButton(
              child: Text('Get Toast Message'),
              onPressed: _getToastMessage,
            ),
            Text(getToastMessage),
          ],
        ),
      ),
    );
  }
}
