import 'package:flutter/material.dart';
import 'package:jedwalak/controls/colors.dart';
import 'package:jedwalak/controls/enums.dart';
import 'package:jedwalak/controls/urls.dart';
import 'package:jedwalak/generated/i18n.dart';
import 'package:jedwalak/models/categoryModel.dart';
import 'package:jedwalak/providers/DeptsProvider.dart';
import 'package:jedwalak/providers/TablesProvider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as math;

alertDialog(
  BuildContext context,
  void Function() onPressed, {
  String title,
  IconData icon = Icons.warning,
}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      transitionBuilder: (contextt, anim1, anim2, child) {
        return Transform.translate(
          child: AlertDialog(
            shape:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            titlePadding: EdgeInsets.all(0),
            title: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$title",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Text(
                          S.of(context).yes,
                          style: TextStyle(fontSize: 16, color: prymaryColor),
                        ),
                        onPressed: onPressed,
                      ),
                      IconButton(
                        icon: Text(
                          S.of(context).no,
                          style: TextStyle(fontSize: 16, color: prymaryColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          offset: Offset(0, 0),
        );
      },
      transitionDuration: Duration(milliseconds: 200));
}

deptDialog(context, {int add = 1, CategoyModel model}) {
  final formKey = new GlobalKey<FormState>();
  var provider = Provider.of<DeptsProvider>(context);
  String name;
  showGeneralDialog(
      context: context,
      pageBuilder: (_, anim1, anim2) {},
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      transitionBuilder: (_, anim1, anim2, child) {
        return Transform.translate(
          child: AlertDialog(
            shape:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            titlePadding: EdgeInsets.all(0),
            title: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(add == 1 ? S.of(context).addDept : S.of(context).editDept),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onSaved: (t) {
                        name = t;
                      },
                      validator: (t) {
                        return t.isEmpty ? S.of(context).cannt_be_null : null;
                      },
                      initialValue: model != null ? model.name : "",
                      decoration: InputDecoration(labelText: S.of(context).dept_name),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            S.of(context).save,
                            style: TextStyle(fontSize: 16, color: prymaryColor),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              {
                                Navigator.pop(context);
                                provider.post(
                                    context,
                                    add,
                                    CategoyModel(
                                        name: name,
                                        id: model != null ? model.id : 0),
                                    f: model);
                              }
                            }
                          },
                        ),
                        FlatButton(
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(fontSize: 16, color: prymaryColor),
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          offset: Offset(0, 0),
        );
      },
      transitionDuration: Duration(milliseconds: 200));
}
