class Message {
  final String senderId;
  final String message;
  final String time;
  final List<List<String>> messageDetails;

  Message({required this.senderId, required this.message, required this.time, required this.messageDetails});

  Message.fromJson(Map<dynamic, dynamic> json)
      : senderId = json['senderId'],
        message = json['message'],
        time = json['time'],
        messageDetails = List<List<String>>.from(json['messageDetails'].map((e) => List<String>.from(e)));

  Map<dynamic, dynamic> toJson() => {
    'senderId': senderId,
    'message': message,
    'time': time,
    'messageDetails': messageDetails.map((e) => e.toList()).toList(),
  };
}
