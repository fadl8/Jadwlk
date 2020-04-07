// To parse this JSON data, do
//
//     final columnModel = columnModelFromJson(jsonString);

import 'dart:convert';

List<ColumnModel> columnModelFromJson(String str) => List<ColumnModel>.from(json.decode(str).map((x) => ColumnModel.fromMap(x)));

String columnModelToJson(List<ColumnModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ColumnModel {
    int id;
    String columnName;
    int tableId;

    ColumnModel({
        this.id,
        this.columnName,
        this.tableId,
    });

    factory ColumnModel.fromMap(Map<String, dynamic> json) => ColumnModel(
        id: json["id"] == null ? null :int.parse( json["id"].toString()),
        columnName: json["columnName"] == null ? null : json["columnName"],
        tableId: json["Table_Id"] == null ? null :int.parse(  json["Table_Id"].toString()),
    );

    Map<String, dynamic> toMap() => {
        "Id":  "$id",
        "columnName": "$columnName",
        "Table_Id":  "$tableId",
    };
}
