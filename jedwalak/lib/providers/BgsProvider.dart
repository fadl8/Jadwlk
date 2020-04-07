
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/models/PhotoModel.dart';  
import 'package:jedwalak/providers/query_model.dart';
import 'package:jedwalak/services/restclient.dart';

class BGsProvider extends QueryModel {
  List<BGsModel> _deptList;
  String _nextUrl;
  bool _loading;
  Apis api;
  

  BGsProvider(String url, ) {
    _nextUrl = url;
    api = new Apis();
    _deptList = [ 
      
      ];
    _loading=false;
   
  }

  set nextUrl(String url) {
    _nextUrl = url;
  }
  

  set deptList(List<BGsModel> c) {
    _deptList = c;
    notifyListeners();
  }

  List<BGsModel> get deptList => _deptList;
  String get nextUrl => _nextUrl;
  bool get loading => _loading;
  

Future getData()async{
  startLoading();
  try{
 await api.getData(Urls.bgs).then((response){
    if(response.status==Status.COMPLETED)
    {
      var data=response.data;
      var m=bGsModelFromJson(data);
      // _nextUrl=m.nextPageUrl;
      _deptList=m ;
     
      
      
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
