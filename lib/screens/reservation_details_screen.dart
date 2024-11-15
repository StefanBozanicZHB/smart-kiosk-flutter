import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
import 'package:smart_kiosk/providers/reservations.dart';
import 'package:smart_kiosk/widgets/image_widget.dart';

class ReservationDetailsScreen extends StatefulWidget {
  static const routeName = '/reservation-details';

  @override
  _ReservationDetailsScreenState createState() => _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final _reservationId = ModalRoute.of(context).settings.arguments;
    final _reservation = Provider.of<Reservations>(context, listen: false);
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _alertDialogForDeleting(context, _reservation, _reservationId);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _reservation.fetchAndSetReservationDetails(_reservationId),
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
              return Container(
                  margin: EdgeInsets.all(20),
                  child: _width > AdditionalFunctions.WIDTH_FOR_CHANGING_ORIENTATION
                      ? _landscapeLayout(_reservation, _width)
                      : _portraitLayout(_reservation));
            }
          }
        },
      ),
    );
  }

  void _alertDialogForDeleting(
      BuildContext context, reservation, reservationId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'Are you sure?',
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
        content: const Text('Do you want to remove the reservation?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: Theme.of(context).textTheme.overline,
              )),
          FlatButton(
              onPressed: () {
                _deleteReservation(context, reservationId);
                Navigator.of(context).pop();
              },
              child: Text('Yes', style: Theme.of(context).textTheme.overline)),
        ],
      ),
    );
  }

  Future<void> _deleteReservation(context, reservationId) async {
    try {
      await Provider.of<Reservations>(context, listen: false)
          .deleteReservation(reservationId);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      _showErrorDialog(context, error.toString());
    } catch (error) {
      const errorMessage =
          'Could not delete the reservation. Please try again later.';
      _showErrorDialog(context, errorMessage);
    }
  }

  void _showErrorDialog(context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An Error Occurred!',
          style: Theme.of(context).textTheme.headline,
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Okay',
              style: Theme.of(context).textTheme.overline,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _landscapeLayout(reservation, width) {
    return Row(
      children: <Widget>[
        Container(
          width: width / 2,
          child: _reservationDetailsWidget(reservation),
        ),
        const SizedBox(
          width: 20,
        ),
        _listViewProducts(reservation),
      ],
    );
  }

  Widget _portraitLayout(reservation) {
    return Column(
      children: <Widget>[
        _reservationDetailsWidget(reservation),
        _listViewProducts(reservation),
      ],
    );
  }

  Widget _listViewProducts(reservation) {
    return
      Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: reservation.reservationDetails.productList.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: AdditionalFunctions.DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS,
                child: SlideAnimation(
                  verticalOffset: AdditionalFunctions.VERTICAL_OFF_SET_ANIMATION,
                  child: ScaleAnimation(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        _productItem(reservation, index),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
  }

  Widget _reservationDetailsWidget(reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${reservation.reservationDetails.kioskName}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
                '${reservation.reservationDetails.paymentMethod.toUpperCase()}'),
            const SizedBox(
              width: 5,
            ),
            reservation.reservationDetails.paymentMethod.toUpperCase() == 'CASH'
                ? Icon(Icons.monetization_on)
                : Icon(Icons.credit_card)
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
            '${reservation.reservationDetails.kioskAddressStreet} ${reservation.reservationDetails.kioskAddressNumber}'),
        const SizedBox(
          height: 10,
        ),
        if (reservation.reservationDetails.orderCode != null)
          Text(
            'Code: #${reservation.reservationDetails.orderCode}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(
          height: 10,
        ),
        Text('${reservation.reservationDetails.statusOrder}'),
        const SizedBox(
          height: 10,
        ),
        Text('${reservation.reservationDetails.timeLastChange}'),
        const SizedBox(
          height: 15,
        ),
        Container(
            width: double.infinity,
            child: Text(
              'Total price: ${reservation.reservationDetails.price} RSD',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            )),
      ],
    );
  }

  Widget _productItem(reservation, index) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageWidget(
                      imageUrl:
                          '${reservation.reservationDetails.productList[index].pictureUrl}',
                    ),
                  ),
                ),
                RotationTransition(
                  turns: const AlwaysStoppedAnimation(-30 / 360),
                  child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        '${reservation.reservationDetails.productList[index].quantity}x',
                        style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.blue[700],
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        '${reservation.reservationDetails.productList[index].quantity}x',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${reservation.reservationDetails.productList[index].name}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        '${reservation.reservationDetails.productList[index].unitPrice} RSD'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Total: ${reservation.reservationDetails.productList[index].unitPrice * reservation.reservationDetails.productList[index].quantity} RSD',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
