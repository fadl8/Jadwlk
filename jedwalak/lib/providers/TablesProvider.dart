import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/PhotoModel.dart';
import 'package:jedwalak/models/TablesModel.dart';
import 'package:jedwalak/models/categoryModel.dart';
import 'package:jedwalak/models/tdataModel.dart';
import 'package:jedwalak/providers/query_model.dart';
import 'package:jedwalak/services/restclient.dart';
import 'package:jedwalak/widgets/flash.dart';
import 'package:jedwalak/widgets/toast.dart';

class TablesProvider extends QueryModel {
  List<TableModel> _tablesList;
  List<TDataModel> _tableDataList;
  String _nextUrl;
  bool _loading;
  Apis api;
  BGsModel _backgraoundPath;

  String _name = "";
  int _id = 0;
  String get name => _name;
  BGsModel get background => _backgraoundPath;
  int get id => _id;

  set name(String c) {
    _name = c;
    notifyListeners();
  }
  set background(BGsModel c) {
    _backgraoundPath = c;
    notifyListeners();
  }

  set id(int c) {
    _id = c;
    notifyListeners();
  }

  List<List<String>> _ddd;
  set ddd(List<List<String>> d) {
    _ddd = d;
    notifyListeners();
  }

  additem(int i, int j, String item) {
    _ddd[i][j] = item;
    notifyListeners();
  }

  List<List<String>> get ddd => _ddd;

  TablesProvider(String url, {String n, int i = 0, int j = 0, int d = 0}) {
    _nextUrl = url;
    _name = n;
    _id = d;
    _ddd = List.generate(i, (_) => List<String>(j));
    api = new Apis();
    _tablesList = [];
    _tableDataList = [];
    _catList = [];
    _imgList=[];
    _loading = false;
  }

  set nextUrl(String url) {
    _nextUrl = url;
  }

  List<CategoyModel> _catList;

  set deptList(List<CategoyModel> c) {
    _catList = c;
    notifyListeners();
  }

  List<CategoyModel> get deptList => _catList;

  set tableDataList(List<TDataModel> c) {
    _tableDataList = c;
    notifyListeners();
  }

  List<TDataModel> get tableDataList => _tableDataList;

  set tableList(List<TableModel> c) {
    _tablesList = c;
    notifyListeners();
  }

  List<TableModel> get tableList => _tablesList;
  String get nextUrl => _nextUrl;
  bool get loading => _loading;

  Future getCat() async {
    startLoadingMore();
    try {
      await api.getData(Urls.categories).then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          var m = categoyModelFromJson(data);
          _catList = m;
        } else {
          errorLoadingMore();
          print("error in get category data");
        }
        finishLoadingMore();
      });
    } catch (e) {
      print(e.toString());
      errorLoadingMore();
    }
  }

  Future getData(int id) async {
    startLoading();
    try {
      await api.getData(_nextUrl).then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          var m = tableModelFromJson(data);
          _tablesList = m;
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

  fillList(int t) {
    _tableDataList = [];
    for (int i = 0; i < ddd.length; i++) {
      for (int j = 0; j < ddd[i].length; j++) {
        _tableDataList.add(TDataModel(
            columnId: i,
            rowId: j,
            userId: Config.getuserid(),
            tableId: t,
            value: ddd[i][j]));
      }
    }
  }

  Future getTableData(int t, int u) async {
    startLoading();
    try {
      await api.getData(Urls.tdata + "/$u/$t").then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          var m = tDataModelFromJson(data);
          _tableDataList = m;
          for (var td in _tableDataList) {
            _ddd[td.columnId][td.rowId] = td.value;
          }
        } else {
          receivedError(["error in get table data list data"]);
          print("error in get table data list data");
        }
        finishLoading();
      });
    } catch (e) {
      print(e.toString());
      receivedError([e]);
    }
  }

  Future post(context, int type, TableModel model, {TableModel f}) async {
    Flushbar flush = flushbar(S.of(context).wait, S.of(context).excuteing);
    flush..show(context);
    try {
      await api
          .postData(
              type == 1 ? Urls.addtab : type == 2 ? Urls.edittab : Urls.deltab,
              data: model != null ? model.toMap() : null)
          .then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          if (data['data'] != null) {
            if (type != 3) {
              _tablesList.add(TableModel.fromMap(data['data']));
              print("addddddddddddddddddd moooooooooooooooooodel "+data.toString());
            } else {
              print(
                  "deeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeellllllllllllllllllllllllll");
              _tablesList.remove(f);
              toast(context,txt:model.toMap().toString());

            }

            toast(context, txt: S.of(context).success);
            flush.dismiss(true);
            notifyListeners();
            if (type != 3) Navigator.pop(context);
          } else {
            toast(context, txt: S.of(context).failed+"  ${data['err']} ");
            flush.dismiss(true);
          }
        } else {
          toast(context, txt: S.of(context).failed);
          flush.dismiss(true);
          print("error in get category data");
        }
      });
    } catch (e) {
      toast(context, txt: S.of(context).no_connect);
      print(e.toString());
      flush.dismiss(true);
    }
  }


  Future addData(context,   model  ) async {
    Flushbar flush = flushbar(S.of(context).wait, S.of(context).excuteing);
    flush..show(context);
    try {
      await api
          .postData(
               Urls.addData ,
              data: model)
          .then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          if (data['data'] != null) {
            toast(context, txt: S.of(context).success);
            flush.dismiss(true);
            notifyListeners();
           
          } else {
            toast(context, txt: S.of(context).failed+" ${data['err']} ");
            flush.dismiss(true);
          }
        } else {
          toast(context, txt: S.of(context).failed);
          flush.dismiss(true);
          print("error in get category data");
        }
      });
    } catch (e) {
      toast(context, txt: S.of(context).no_connect);
      print(e.toString());
      flush.dismiss(true);
    }
  }

 List<BGsModel> _imgList;
set imgtList(List<BGsModel> c) {
    _imgList = c;
    notifyListeners();
  }
 List<BGsModel> get imgtList => _imgList;
 

Future getImages()async{
  startLoading();
  try{
 await api.getData(Urls.bgs).then((response){
    if(response.status==Status.COMPLETED)
    {
      var data=response.data;
      var m=bGsModelFromJson(data);
      // _nextUrl=m.nextPageUrl;
      _imgList=m ;
     
      
      
    }
    else
    {
      receivedError(["error in get category data"]);
    }
    finishLoading();
  });

  }catch(e)
  {
    receivedError(e);
  }
 }


}
