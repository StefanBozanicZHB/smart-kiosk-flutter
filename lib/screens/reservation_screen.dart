import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/providers/reservations.dart';
import 'package:smart_kiosk/widgets/reservation_item.dart';

class ReservationScreen extends StatelessWidget {
  static const routeName = '/reservation-screen';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<Reservations>(context, listen: true).fetchAndSetReservation(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: const Text('An error occurred!'),
            );
          } else {
            return Consumer<Reservations>(
              builder: (ctx, orderData, child) =>
                  orderData.reservation.length == 0
                      ? const Text(
                          'Nema podataka za ovaj telefon',
                        )
                      : AnimationLimiter(
                    child: ListView.builder(
                      itemCount: orderData.reservation.length,
                      itemBuilder: (ctx, index) =>
                          AnimationConfiguration.staggeredList(
                            position: index,
                            duration: AdditionalFunctions
                                .DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS,
                            child: SlideAnimation(
                              verticalOffset: AdditionalFunctions
                                  .VERTICAL_OFF_SET_ANIMATION,
                              child: ScaleAnimation(
                                child: ReservationItemWidget(orderData.reservation[index]),
                              ),
                            ),
                          ),
                    ),
                  ),
//                          physics: AlwaysScrollableScrollPhysics(),
            );
          }
        }
      },
    );
  }
}
