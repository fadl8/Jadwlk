import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
// import 'package:ext_storage/ext_storage.dart';
// import 'package:file_utils/file_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/TablesModel.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';

GlobalKey _globalKey = new GlobalKey();

Future<String> capturePng(context, name) async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  try {
    print('inside');

    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    var dir;
    final buffer = byteData.buffer;
    bool isShown = true;
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.denied) {
      isShown = await PermissionHandler()
          .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
    }
    if (isShown) {
      if (permission == PermissionStatus.granted) {
        if (Platform.isAndroid) {
          dir = "/sdcard/جدولك";
          try {
          await Directory(dir).create(recursive: true);
          File(dir + "/$name.png").writeAsBytes(buffer.asUint8List(
              byteData.offsetInBytes, byteData.lengthInBytes));
          print('png done');
          Flushbar<bool>(
            title: S.of(context).successSaveImage, 
            message: dir + "/$name.jpg",
            duration: Duration(seconds: 2),
            isDismissible: false,
          )..show(context);
        } 
        catch (e) {
          print(e);
        }
        } else {
          dir = (await getApplicationDocumentsDirectory()).path;
        }
        
      }
    }
  } catch (e) {
    print(e);
  }
}

imge(TableModel model, BuildContext context, Color color) {
  var provider = Provider.of<TablesProvider>(context);
  var cols = model.cols.map((f) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        "${f.columnName}",
        style: TextStyle(color: Colors.white, fontSize: 10),
        textAlign: TextAlign.center,
      )),
    );
  }).toList();

  List<TableRow> rows = provider.ddd.map((f) {
    var col = f.map((f) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          "$f",
          style: TextStyle(fontSize: 10, color: color),
          textAlign: TextAlign.center,
        )),
      );
    }).toList();
    return TableRow(
        decoration: BoxDecoration(
            color: provider.ddd.indexOf(f) % 2 == 0
                ? prymaryColor.withOpacity(.2)
                : null),
        children: col);
  }).toList();

  rows.insert(0,
      TableRow(decoration: BoxDecoration(color: prymaryColor), children: cols));

  return RepaintBoundary(
    key: _globalKey,
    child: Container(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    model.bg != null ? model.bg.path : " "),
                fit: BoxFit.fill)),
        child: Table(
          border: TableBorder.all(),
          children: rows,
        ),
        // child: DataTable(
        //     headingRowHeight: 80,
        //     columns: cols,
        //     rows: !editmod ? viewList : inputList),
      ),
    ),
  );
}
