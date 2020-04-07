import 'dart:async';
import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:jedwalak/controls/enums.dart';
import 'fetch_exception.dart';
import 'network_service_response.dart';

class Apis {
  Future<bool> checkInternet() async {
    var isDeviceConnected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isDeviceConnected = await DataConnectionChecker().hasConnection;
      return Future.value(isDeviceConnected);
    } else {
      return Future.value(isDeviceConnected);
    }
  }

//Todo use the Dio
  Future<ResponsData<T>> getData<T>(String resourcePath ,{Map<String,String> header}) async {
    print("get");
    if (1==1) {
      var response = await http.get(
        resourcePath,
        headers:header
      );
      return getResponse<T>(response);
    }
    throw [NoConnectionException("no connection")];
  }

  Future<ResponsData<T>> postData<T>(String resourcePath,
   { data,Map<String,String> header
      }
      ) async {
    // var content = json.encoder.convert(data) ;
    // != null ? json.encoder.convert(data) : jsonbody;
    if (1==1) {
      var response = await http.post(
        resourcePath,
        body: data,
        headers: header
      );
      print("sdfffffffffffffffffffffffffffffffffffffffffff=${response.body}");
      return getResponse<T>(response);
    }
    throw [NoConnectionException("no connection")];
  }

  ResponsData<T> getResponse<T>(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          var jsonResult = response.body;
          dynamic resultClass = jsonDecode(jsonResult);
          return ResponsData<T>(status: Status.COMPLETED, data: resultClass);
        }
        break;
      case 400:
        {
          var errorResponse = response.body;
          dynamic resultClass = jsonDecode(errorResponse);
          ResponsData<T>.error(resultClass['errors']);
        }
        break;
      case 401:

      case 403:
        throw [UnauthorisedException("error unauthorised ")];
        break;
      case 500:
       
      default:
        throw [FetchDataException("fetch data error")];
    }
  }
}
