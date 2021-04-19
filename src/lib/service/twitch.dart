import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart';

class TwitchService {
  StreamController<TwitchMessageEvent> _messageStreamController;

  TwitchService() {
    _messageStreamController = new StreamController();
    Socket socket = io('http://localhost:3000');
    socket.on(
      'twitch_chat',
      (data) => _messageStreamController.add(
        TwitchMessageEvent(
          date: DateTime.parse(data['date']),
          owner: data['owner'],
          text: data['text'],
          targets: data['targets'],
        ),
      ),
    );
  }

  void close() {
    _messageStreamController.close();
  }

  Stream<TwitchMessageEvent> streamMessageEvents() =>
      _messageStreamController.stream.asBroadcastStream();
}

abstract class TwitchEvent {
  final String owner;
  final String text;
  final DateTime date;

  TwitchEvent({this.owner, this.text, this.date});
}

class TwitchMessageEvent extends TwitchEvent {
  final List<String> targets;

  TwitchMessageEvent({owner, text, date, this.targets})
      : super(date: date, text: text, owner: owner);
}
