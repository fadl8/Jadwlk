// To parse this JSON data, do
//
//     final tDataModel = tDataModelFromJson(jsonString);

import 'dart:convert';

List<TDataModel> tDataModelFromJson( str) => List<TDataModel>.from((str).map((x) => TDataModel.fromMap(x)));

String tDataModelToJson(List<TDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TDataModel {
    int id;
    int tableId;
    int userId;
    int columnId;
    int rowId;
    String value;

    TDataModel({
        this.id,
        this.tableId,
        this.userId,
        this.columnId,
        this.rowId,
        this.value,
    });

    factory TDataModel.fromMap(Map<String, dynamic> json) => TDataModel(
        id: json["id"] == null ? null :int.parse( json["id"].toString()),
        tableId: json["table_id"] == null ? null :int.parse( json["table_id"].toString()),
        userId: json["user_id"] == null ? null :int.parse( json["user_id"].toString()),
        columnId: json["column_id"] == null ? null :int.parse( json["column_id"].toString()),
        rowId: json["row_id"] == null ? null :int.parse( json["row_id"].toString()),
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toMap() => {
        "id":   "$id",
        "table_id":   "$tableId",
        "user_id":   "$userId",
        "column_id":   "$columnId",
        "row_id":   "$rowId",
        "value": "$value",
    };
}
