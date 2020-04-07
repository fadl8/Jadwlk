import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/generated/i18n.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(
        elevation: 0,
        title: Text(S.of(context).aboutUs),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: prymaryColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
    SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
  
                  decoration: BoxDecoration(
  
                    color: Colors.white38,
  
                    borderRadius:BorderRadius.circular(20)
  
                  ),
  
                  child: Center(child: 
  
                  Text(S.of(context).about,textAlign: TextAlign.center,style: TextStyle(
  
                    color: Colors.white ,fontSize: 20,fontWeight: FontWeight.bold
  
                  ),)
  
                  ,),
  
                ),
    ),
],
          ),
        ),
      ),
      
    );
  }
}