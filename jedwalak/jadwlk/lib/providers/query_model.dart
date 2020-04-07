
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jedwalak/controls/enums.dart';
 

abstract class QueryModel with ChangeNotifier {
  List<dynamic> errors = List();
  
// Types _types;
// set type(Types t) {
//     _types = t;
//   }
// Types get type => _types;

    Status _status;
  Status _loadMoreError;
    Status get status => _status;
    Status get loadMore => _loadMoreError;
    set status(value) => _status = value;

    bool get isInit => _status == Status.INIT;
    bool get isloading => _status == Status.LOADING;
    bool get iscomplated => _status == Status.COMPLETED;

    QueryModel() {
      _status = Status.INIT;
      
      
    _loadMoreError=Status.COMPLETED;
    }
    
    void startLoading() {
      _status = Status.LOADING;
      notifyListeners();
    }

    void finishLoading() {
      _status = Status.COMPLETED;
      notifyListeners();
    }

    void receivedError(List errors) {
      this.errors = errors;
      _status = Status.ERROR;

      notifyListeners();
    }
    
 startLoadingMore(){
  
  _loadMoreError=Status.LOADING;
notifyListeners();
}


 errorLoadingMore(){
  
  _loadMoreError=Status.ERROR;
notifyListeners();
}
 finishLoadingMore(){
 
  _loadMoreError=Status.COMPLETED;
notifyListeners();
}
 
 
}
