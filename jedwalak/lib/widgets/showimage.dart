
import 'package:flutter/material.dart';
import 'package:jedwalak/widgets/network_image.dart';

class ShowImage extends StatelessWidget {
  String tag;
  ShowImage(this.tag);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            child: Hero(
              tag: tag,
              child: PNetworkImage(tag),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              MaterialButton(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Icon(Icons.close),
                color: Colors.white,
                textColor: Colors.black,
                minWidth: 0,
                height: 40,
                onPressed: () => Navigator.pop(context),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
