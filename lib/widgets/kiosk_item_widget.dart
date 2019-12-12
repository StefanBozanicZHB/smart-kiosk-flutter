import 'package:flutter/material.dart';
import 'package:smart_kiosk/providers/kiosks.dart';

class KioskItemWidget extends StatelessWidget {
  final KioskItem kiosk;

  KioskItemWidget(this.kiosk);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(kiosk.name),
                    Text('${kiosk.streetName}, ${kiosk.streetNumber}'),
                    Text('#${kiosk.id}'),
                  ],
                ),
              ),
              kiosk.isFavourite
                  ? IconButton(icon: Icon(Icons.favorite), onPressed: () {})
                  : IconButton(icon: Icon(Icons.favorite_border), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
