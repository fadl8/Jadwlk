// import 'package:vmart/app/utils/Enums/status.dart';

import 'package:jedwalak/controls/enums.dart';

class ResponsData<T> {
  Status status;
  dynamic message;
  dynamic data;

  //to use in future
  ResponsData.loading(this.message) : status = Status.LOADING;
  ResponsData.completed(this.data) : status = Status.COMPLETED;
  ResponsData.error(this.message) : status = Status.ERROR;

  ResponsData({this.status, this.message, this.data});
} 
