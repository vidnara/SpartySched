class MessageList {
  final List<Message> messages;

  MessageList(this.messages);

  factory MessageList.fromJson(List<dynamic> json) {
    List<Message> messages = json.map((item) => Message.fromJson(item)).toList();
    return MessageList(messages);
  }

  List<dynamic> toJson() => messages.map((message) => message.toJson()).toList();

  MessageList merge(MessageList other) {
    List<Message> mergedMessages = List.from(messages)..addAll(other.messages);
    mergedMessages.sort((a, b) => a.time.compareTo(b.time));
    return MessageList(mergedMessages);
  }
}

class Message {
  final String senderId;
  final String message;
  final String time;

  Message({required this.senderId, required this.message, required this.time});

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      message: json['message'],
      time: json['time'],
    );
  }

  Map<dynamic, dynamic> toJson() => {
    'senderId': senderId,
    'message': message,
    'time': time,
  };
}
