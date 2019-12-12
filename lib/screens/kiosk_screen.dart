import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/providers/reservations.dart';
import 'package:smart_kiosk/widgets/kiosk_item_widget.dart';
import 'package:smart_kiosk/widgets/reservation_item.dart';

class KioskScreen extends StatefulWidget {
  static const routeName = '/kiosk-screen';

  @override
  _KioskScreenState createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kiosk sreach'),
        ),
        body:
      FutureBuilder(
          future: Provider.of<Kiosks>(context).fetchAndSetKiosks(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: const Text('An error occurred!'),
                );
              } else {
                return Consumer<Kiosks>(
                  builder: (ctx, kioskData, child) =>
                      kioskData.kiosks.length == 0
                          ? const Text(
                              'Nema podataka',
                            )
                          : ListView.builder(
                              itemCount: kioskData.kiosks.length,
                              itemBuilder: (ctx, index) => KioskItemWidget(kioskData.kiosks[index]),
                            ),
                );
              }
            }
          }),
        );
  }
}
