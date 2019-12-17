import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/cart.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/screens/cart_screen.dart';
import 'package:smart_kiosk/screens/main_screen.dart';
import 'package:smart_kiosk/screens/reservation_screen.dart';

class FirstScreen extends StatefulWidget {
  static const routeName = '/first-screen';

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'title': 'Smart-kiosk',
      'page': MainScreen(),
    },
    {
      'title': 'Cart',
      'page': CartScreen(),
    },
    {
      'title': 'Reservation',
      'page': ReservationScreen(),
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
//    Provider.of<Kiosks>(context, listen: false).fetchAndSetFavoriteKiosks();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _screenForDisplay = ModalRoute.of(context).settings.arguments;
    if (_screenForDisplay != null && !_isLoading) {
      if (_screenForDisplay == CartScreen.routeName) {
        setState(() {
          _selectedPageIndex = 1;
          _isLoading = true;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          if (_pages[_selectedPageIndex]['title'] == 'Cart' && Provider.of<Cart>(context).cart.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                          Provider.of<Cart>(context, listen: false).clearCart();
                        },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    print('send');
                  },
                )
              ],
            )
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
//        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.library_books),
            title: Text('Reservation'),
          ),
        ],
      ),
    );
  }
}

List<Widget> actionWidgetForCart() {
  Consumer<Cart>(builder: (ctx, cartData, child) {
    if (!cartData.cart.isEmpty) {
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print('delete');
            },
          )
        ],
      );

//          IconButton(
//            icon: Icon(Icons.send),
//            onPressed: () {
//              print('send');
//            },
//    )
    }
  });
}
