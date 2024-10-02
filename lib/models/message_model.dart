import 'package:chat_app/widgets/constants.dart';

class MessageModel {
  final String? message;
final String?id;
  MessageModel(this.id, {required this.message});

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(message: jsonData[kMessage],jsonData['id']);
  }
}
