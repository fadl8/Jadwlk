import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';


void prog({context,txt="الرجاء الانتظار قليلا"}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          //backgroundColor: Theme.of(context).primaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(txt.toString(),style: TextStyle(color: prymaryColor),),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ColorLoader4(
                    //     dotOneColor: Colors.red,
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}


progress({txt="جاري تحميل البيانات"}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(height: 15,),
      // ColorLoader4(
      //   dotOneColor: Colors.blue,
      //   dotTwoColor: Colors.green,
      //   dotThreeColor: Colors.orange,
      //   dotType: DotType.circle,
      //   dotIcon: Icon(Icons.adjust),
      //   duration: Duration(milliseconds: 800),
      // ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "$txt",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      )
    ],
  );
}
