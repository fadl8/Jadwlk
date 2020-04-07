import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/categoryModel.dart';
import 'package:jedwalak/providers/query_model.dart';
import 'package:jedwalak/services/restclient.dart';
import 'package:jedwalak/widgets/flash.dart';
import 'package:jedwalak/widgets/toast.dart';
import 'package:flushbar/flushbar.dart';
class DeptsProvider extends QueryModel {
  List<CategoyModel> _catList;
  String _nextUrl;
  bool _loading;
  Apis api;

  DeptsProvider() {
    _nextUrl = Urls.categories;
    api = new Apis();
    _catList = [];
    _loading = false;
  }

  set nextUrl(String url) {
    _nextUrl = url;
  }

  set deptList(List<CategoyModel> c) {
    _catList = c;
    notifyListeners();
  }

  List<CategoyModel> get deptList => _catList;
  String get nextUrl => _nextUrl;
  bool get loading => _loading;

  Future getData() async {
    startLoading();
    try {
      await api.getData(_nextUrl).then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          var m = categoyModelFromJson(data);
          _catList = m;
        } else {
          receivedError(["error in get category data"]);
          print("error in get category data");
        }
        finishLoading();
      });
    } catch (e) {
      print(e.toString());
      receivedError([e]);
    }
  }

  Future post(context, int type, CategoyModel model, {CategoyModel f}) async {
   Flushbar  flush = flushbar(S.of(context).wait, S.of(context).excuteing);
          flush..show(context);        
    // startLoadingMore();
    try {
  
      await api
          .postData(
              type == 1 ? Urls.addcat : type == 2 ? Urls.editcat : Urls.delcat,
              data: model != null ? model.toMap() : null)
          .then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          if (data['data'] != null) {
            if (type == 1) {
              _catList.add(CategoyModel.fromMap(data['data']));
            } else if (f != null) {
              if (type == 2) {
                int i = _catList.indexOf(f);
                _catList[i] = CategoyModel.fromMap(data['data']);
              } else
                _catList.remove(f);
            }
            notifyListeners(); 
            
            toast(context, txt: S.of(context).success);
           
          } else
            toast(context, txt: S.of(context).faild_upload+" ${data['err']} ");
            // flush.dismiss(true);
        } else {
          toast(context, txt: S.of(context).faild_upload);
          // flush.dismiss(true);
          // receivedError(["error in get category data"]);
          print("error in get category data");
        }
        // finishLoading();
      });
    } catch (e) {
      toast(context, txt: S.of(context).no_connect);
      print(e.toString());
      // receivedError([e]);
    }
     flush.dismiss(true);

  }
}
