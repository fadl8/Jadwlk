// To parse this JSON data, do
//
//     final categoyModel = categoyModelFromJson(jsonString);

import 'dart:convert';

List<CategoyModel> categoyModelFromJson(dynamic str) => List<CategoyModel>.from(str.map((x) => CategoyModel.fromMap(x)));

String categoyModelToJson(List<CategoyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CategoyModel {
    int id;
    String name;

    CategoyModel({
        this.id,
        this.name,
    });

    factory CategoyModel.fromMap(Map<String, dynamic> json) => CategoyModel(
        id: json["id"] == null ? null :int.parse(json["id"].toString()),
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": "$id"  ,
        "name":   "$name",
    };
}
