import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/pages/registerPage.dart';
import 'package:jedwalak/providers/HomeIndex.dart';
import 'package:provider/provider.dart';

class SugPage extends StatefulWidget {
  @override
  _SugPageState createState() => _SugPageState();
}

class _SugPageState extends State<SugPage> {
   final loginKey = new GlobalKey<FormState>();
  String un;
  String password;
  bool isPasswordVisible = true;
  bool unError = false;
  String username;
   userName() => Card(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 10,
          onSaved: (txt) {
            un = txt;
          },
          validator: (txt) {
            return txt.isEmpty
                ? S.of(context).cannt_be_null
                // : !EmailValidator.validate(txt, true)
                //     ? "البريد الالكتروني غير صحيح"
                    : null;
          },
          style: TextStyle(fontSize: 16, color: prymaryColor),
          decoration: InputDecoration(
              labelText: S.of(context).writeSug,
              prefixIcon: Icon(Icons.comment),
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
        ),
   );

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(S.of(context).sug,),
                          centerTitle: true,
      ) ,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Container(
            padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: prymaryColor
                ),
                child: Center(
                  child: SingleChildScrollView(
                                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Image(image: AssetImage("images/logow.png")),
                        ),
                        
                        Form(
                          key: loginKey,
                          child: Column(
                            children: <Widget>[
                               SizedBox(
                            height: 30,
                          ),
                          userName(),
                          SizedBox(
                            height: 8,
                          ),
                         
                              provider.status!=Status.LOADING
                              ? Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 42,
                                      onPressed: () {
                                        var index = Provider.of<HomeProvider>(context);
                                        if (loginKey.currentState.validate()) {
                                          loginKey.currentState.save();
                                          index.send(context,un);
                                           }
                                      },
                                      color: accentColor,
                                      child: Text(
                                        S.of(context).send,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      // backgroundColor: prymaryColor,
                                      )),

                                     

                            ],
                        ),)
                      ],
                    ),
                  ),
                ),
            ),
          ),
    );
  }
}