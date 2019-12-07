import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/reservations.dart';
import 'package:smart_kiosk/widgets/reservation_item.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = 'reservation-screen';

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<Reservations>(context, listen: false).fetchAndSetReservation(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error occurred!'),
            );
          } else {
            return Consumer<Reservations>(
              builder: (ctx, orderData, child) =>
                  orderData.reservation.length == 0
                      ? Text(
                          'Nema podataka za ovaj telefon',
                        )
                      : ListView.builder(
                          itemCount: orderData.reservation.length,
                          itemBuilder: (ctx, i) =>
                              ReservationItemWidget(orderData.reservation[i]),
                        ),
            );
          }
        }
      },
    );
  }
}
