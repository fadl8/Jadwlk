import 'package:flushbar/flushbar.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/sugModel.dart';
import 'package:jedwalak/providers/query_model.dart';
import 'package:jedwalak/services/restclient.dart';
import 'package:jedwalak/widgets/flash.dart';
import 'package:jedwalak/widgets/toast.dart';

class SugProvider extends QueryModel {
  List<SugModel> _tablesList;
  String _nextUrl;
  bool _loading;
  Apis api;
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

  SugProvider(String url, {int i = 0, int j = 0}) {
    _nextUrl = url;
    _ddd = List.generate(i, (_) => List<String>(j));
    api = new Apis();

    _tablesList = [];
    _loading = false;
  }

  set nextUrl(String url) {
    _nextUrl = url;
  }

  set deptList(List<SugModel> c) {
    _tablesList = c;
    notifyListeners();
  }

  List<SugModel> get deptList => _tablesList;
  String get nextUrl => _nextUrl;
  bool get loading => _loading;

  Future getData() async {
    startLoading();
    try {
      await api.getData(Urls.msgs).then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          var m = sugModelFromJson(data);
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

  Future post(context, SugModel f) async {
    Flushbar flush = flushbar(S.of(context).wait, S.of(context).excuteing);
    flush..show(context);
    try {
      await api
          .postData(
        Urls.delMsg,
        data: f.toMap()
      )
          .then((response) {
        if (response.status == Status.COMPLETED) {
          var data = response.data;
          if (data['data'] != null) {
            _tablesList.remove(f);
            notifyListeners();
            toast(context, txt: S.of(context).success);
          } else
            toast(context, txt: S.of(context).failed+" ${data['err']} ");
        } else {
          toast(context, txt: S.of(context).failed);
          print("error in get category data");
        }
      });
    } catch (e) {
      toast(context, txt: S.of(context).no_connect);
      print(e.toString());
    }
    flush.dismiss(true);
  }
}
