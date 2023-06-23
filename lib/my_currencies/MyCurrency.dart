import 'package:flutter/material.dart';

class MyCurrencyInfo extends StatelessWidget {
  //const MyCurrencyInfo({super.key});
  final String _image;
  final String _title;
  const MyCurrencyInfo(this._image, this._title);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.network("http://10.0.2.2:9090/$_image",
                  width: 70, height: 70),
            ),
            Text(_title)
          ],
        ),
      ),
    );
  }
}
