class Message {
  late String senderId;
  late String recieverid;
  late String message;
  late String type;
  late String sent;
  late String read;

  Message({
    required this.senderId,
    required this.recieverid,
    required this.message,
    required this.type,
    required this.sent,
    required this.read,
  });

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'] ?? '';
    recieverid = json['recieverId'] ?? '';
    message = json['message'] ?? '';
    sent = json['sent'] ?? '';
    read = json['read'] ?? false;
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['recieverId'] = recieverid;
    data['message'] = message;
    data['sent'] = sent;
    data['read'] = read;
    data['type'] = type;

    return data;
  }
}
