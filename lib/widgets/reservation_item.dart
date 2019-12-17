import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/screens/reservation_details_screen.dart';
import '../providers/reservations.dart' as ord;

class ReservationItemWidget extends StatefulWidget {
  final ord.ReservatioItem _reservation;

  ReservationItemWidget(this._reservation);

  @override
  _ReservationItemWidgetState createState() => _ReservationItemWidgetState();
}

class _ReservationItemWidgetState extends State<ReservationItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ReservationDetailsScreen.routeName, arguments: widget._reservation.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${widget._reservation.kioskName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    widget._reservation.icon,
                    color: widget._reservation.color,
                    size: 24.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget._reservation.price} RSD',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget._reservation.paymentMethod.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${widget._reservation.timeLastChange}')
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      '${widget._reservation.statusMessage}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  widget._reservation.reservationStatusId == 3
                      ? IconForResending(widget._reservation.id)
                      : Text('')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconForResending extends StatefulWidget {
  final reservationId;

  IconForResending(this.reservationId);

  @override
  _IconForResendingState createState() => _IconForResendingState();
}

class _IconForResendingState extends State<IconForResending> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.red,
              size: 35,
            ),
            onPressed: () {
              print('refresh ${widget.reservationId}');

              setState(() {
                _isLoading = true;
              });

              Future.delayed(
                const Duration(seconds: 1),
                () async {
                  final response = await Provider.of<ord.Reservations>(context)
                      .updateReservation(widget.reservationId);
                  setState(() {
                    _isLoading = false;
                  });

                  var _message;
                  if (response.success) {
                    _message =
                        'Success send reservation. Code: ${response.orderCode}';
                  } else {
                    _message = 'Something is wrong!';
                  }
                  print(_message);

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reservation'),
                      content:
                          Text(_message),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Okey')),
                      ],
                    ),
                  );
                },
              );
            },
          );
  }
}
