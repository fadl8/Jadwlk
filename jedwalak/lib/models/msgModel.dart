// To parse this JSON data, do
//
//     final msgModel = msgModelFromJson(jsonString);

import 'dart:convert';

List<MsgModel> msgModelFromJson(String str) => List<MsgModel>.from(json.decode(str).map((x) => MsgModel.fromMap(x)));

String msgModelToJson(List<MsgModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class MsgModel {
    String id;
    String messageText;
    DateTime createTime;

    MsgModel({
        this.id,
        this.messageText,
        this.createTime,
    });

    factory MsgModel.fromMap(Map<String, dynamic> json) => MsgModel(
        id: json["Id"] == null ? null : json["Id"],
        messageText: json["message_text"] == null ? null : json["message_text"],
        createTime: json["createTime"] == null ? null : DateTime.parse(json["createTime"]),
    );

    Map<String, dynamic> toMap() => {
        "Id": id == null ? null : id,
        "message_text": messageText == null ? null : messageText,
        "createTime": createTime == null ? null : createTime.toIso8601String(),
    };
}
