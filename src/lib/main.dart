import 'package:flutter/material.dart';
import 'package:src/service/twitch.dart';

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
      ),
      home: ObsOverlay(
        service: TwitchService(),
      ),
    );
  }
}

class ObsOverlay extends StatelessWidget {
  final TwitchService service;
  const ObsOverlay({Key key, this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatOverlay(messageStream: service.streamMessageEvents());
  }
}

class ChatOverlay extends StatelessWidget {
  final Stream<TwitchMessageEvent> messageStream;
  const ChatOverlay({Key key, this.messageStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: StreamBuilder<TwitchMessageEvent>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var message = snapshot.data;
            var displayedText = "${message.owner}: ${message.text}";
            return Text(
              displayedText,
              style: TextStyle(fontSize: 40, color: Colors.red),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
