// To parse this JSON data, do
//
//     final sugModel = sugModelFromJson(jsonString);

import 'dart:convert';

List<SugModel> sugModelFromJson(  str) => List<SugModel>.from( (str).map((x) => SugModel.fromMap(x)));

String sugModelToJson(List<SugModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class SugModel {
    int id;
    String messageText;
    String createTime;

    SugModel({
        this.id,
        this.messageText,
        this.createTime,
    });

    factory SugModel.fromMap(Map<String, dynamic> json) => SugModel(
        id: json["id"] == null ? null : json["id"],
        messageText: json["message_text"] == null ? null : json["message_text"],
        createTime: json["createTime"] == null ? null : json["createTime"],
    );

    Map<String, dynamic> toMap() => {
        "id": "$id" ,
        "message_text": "$messageText" ,
        "createTime": "$createTime"  ,
    };
}
