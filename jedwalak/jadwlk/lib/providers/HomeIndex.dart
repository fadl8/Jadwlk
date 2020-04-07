import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/userModel.dart';
import 'package:jedwalak/providers/query_model.dart';
import 'package:jedwalak/services/restclient.dart';
import 'package:jedwalak/widgets/toast.dart';

class HomeProvider extends QueryModel {
  int _counter;
  bool _editInfo;

  bool _changPass;
  bool _login;
  Apis api;

  HomeProvider(
    int c,
  ) {
    _counter = c;
    api = new Apis();
    _changPass = false;
    _editInfo = false;

    _login = Config.getlogin();
  }

  set login(bool l) {
    _login = l;
    Config.setlogin(l);
    notifyListeners();
  }

  setCounter(int counter) {
    _counter = counter;
    notifyListeners();
  }

  setStaus(int counter) {
    status = counter;
    notifyListeners();
  }

  set changPass(bool op) {
    _changPass = op;
    notifyListeners();
  }

  set editInfo(bool op) {
    _editInfo = op;
    notifyListeners();
  }

  getCounter() => _counter;

  bool get login => _login;
  bool get editInfo => _editInfo;
  bool get changPass => _changPass;

  Future doLogin(context, email, pass) async {
    startLoading();
    toast(context, txt: S.of(context).logining);
    try {
      await api.postData(Urls.login,
          data: {"email": "$email", "pass": "$pass"}).then((response) {
        if (response.status == Status.COMPLETED) {
          var l = response.data;
          if (l['data'] != null) {
            var data = UserModel.fromMap(response.data['data']);
            Config.setuserid(data.id);
            Config.setfname(data.name);
            Config.setEmail(data.email);
            Config.settype(data.type);

            Config.setlogin(true);
            login = true;

            toast(context, txt: S.of(context).successLogin, pop: true);
          } else {
            toast(
              context,
              txt: S.of(context).passoremailerror,
            );
          }
        } else {
          toast(context, txt: S.of(context).failedlogin);
          receivedError(["error in get category data"]);
        }
        finishLoading();
      });
    } catch (e) {
      receivedError([e]);
      toast(context, txt: S.of(context).failedlogin+" \n ${e.toString()}");
    }
  }

  Future regiser(context, UserModel user) async {
    startLoading();
    toast(context, txt: S.of(context).registering);
    try {
      await api.postData(Urls.register, data: user.toMap()).then((response) {
        if (response.status == Status.COMPLETED) {
          var l = response.data;
          if (l['data'] != null) {
            var data = UserModel.fromMap(response.data['data']);
            Config.setuserid(data.id);
            Config.setfname(data.name);
            Config.setEmail(data.email);
            Config.settype(data.type);
            Config.setlogin(true);
            login = true;

            toast(context, txt: S.of(context).successLogin, pop: true);
          } else {
            toast(
              context,
              txt: S.of(context).error+" ${l['err']}",
            );
          }
        } else {
          toast(context, txt: S.of(context).successLogin);
          receivedError(["error in get category data"]);
        }
        finishLoading();
      });
    } catch (e) {
      receivedError([e]);
      toast(context, txt: S.of(context).failedlogin+"  \n ${e.toString()}");
    }
  }

  Future send(context, msg) async {
    startLoading();
    toast(context, txt: S.of(context).sending);
    try {
      await api.postData(
        Urls.addmsg,
        data: {"msg": "$msg"},
      ).then((response) {
        if (response.status == Status.COMPLETED) {
          print(response.data.toString());

          toast(context, txt: S.of(context).successSend, pop: true);
        } else {
          toast(
            context,
            txt: S.of(context).failedSend,
          );
        }

        finishLoading();
      });
    } catch (e) {
      receivedError([e]);
      toast(context, txt: S.of(context).failedSend+" \n ${e.toString()}");
    }
  }
}
