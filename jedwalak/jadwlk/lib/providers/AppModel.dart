
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/getShare.dart';
import 'package:jedwalak/providers/query_model.dart';
  

class AppModel extends QueryModel {
String local=Config.getLang(); 
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldState> get scaffoldKey=> _scaffoldKey;
int _index=0;
set index(int i)
{
  _index=i;
  notifyListeners();
}

int get index=> _index;
operDrawer()
{
  _scaffoldKey.currentState.openDrawer();
  notifyListeners();
}
bool islogin=Config.getlogin(); 
setLang(String lang)
{
  local=lang;
  Config.setLang(lang);
  notifyListeners();
}
setLogin(bool log)
{
  islogin=log;
  Config.setlogin(log);
  notifyListeners();
}

Future init() async {
notifyListeners();
}
}
