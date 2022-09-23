import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    super.initState();
  }

  String mytext = "";
  void onConnectPressed() async {
    try {
      await pusher.init(
          apiKey: "ec7cfae54b4580d00b85",
          cluster: "mt1",
        onEvent: onEvent,
      );
      await pusher.subscribe(
          channelName: "my-channel",
      );
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }
  void onEvent(PusherEvent event) {
    setState((){
      mytext = "${event.data['name']}";
    });
    print("onEvent: ${event.data}");
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(pusher.connectionState == 'DISCONNECTED'
              ? 'Pusher Channels Example'
              : "connected now"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: [
              Text(mytext),
              ElevatedButton(
                onPressed: onConnectPressed,
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}