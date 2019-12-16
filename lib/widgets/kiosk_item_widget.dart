import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/screens/products_list_screen.dart';

class KioskItemWidget extends StatelessWidget {
  final KioskItem kiosk;

  KioskItemWidget(this.kiosk);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductsListScreen.routeName, arguments: kiosk);
      },
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
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/map_and_marker.png',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      kiosk.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${kiosk.streetName}, ${kiosk.streetNumber}'),
                    Text('#${kiosk.id}'),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    kiosk.isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    try{
                      await Provider.of<Kiosks>(context, listen: false).changeFavorite(!kiosk.isFavourite, kiosk.id);
                    } catch (error){
                      final snackBar = SnackBar(content: const Text('Check internet connection!'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    print(kiosk.isFavourite);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
