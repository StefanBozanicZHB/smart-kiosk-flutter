import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/kiosk.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/screens/kiosk_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<Kiosks>(context, listen: false).fetchAndSetFavoriteKiosks();
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(4, (index) {
        return ItemMenu(index);
      }),
    );
  }
}

class ItemMenu extends StatefulWidget {
  final _index;

  ItemMenu(this._index);

  @override
  _ItemMenuState createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  String _title;
  String _image;
  String _nextHop;
  MainMenu _typeOfMainScreen;
  String _titleOfScreen;

  @override
  void initState() {
    super.initState();
    switch (widget._index) {
      case 0:
        _title = 'Nearest kiosks';
        _image = 'assets/images/map_and_marker.png';
        _nextHop = KioskScreen.routeName;
        _typeOfMainScreen = MainMenu.byLocation;
        _titleOfScreen = 'Nearest kiosks';
        break;
      case 1:
        _title = 'Search kiosks by name or number';
        _image = 'assets/images/marker_with_number.jpg';
        _nextHop = KioskScreen.routeName;
        _typeOfMainScreen = MainMenu.byName;
        _titleOfScreen = 'Search kiosks by name or number';
        break;
      case 2:
        _title = 'Search kiosk by street name';
        _image = 'assets/images/street.png';
        _nextHop = KioskScreen.routeName;
        _typeOfMainScreen = MainMenu.byStreet;
        _titleOfScreen = 'Search kiosk by street name';
        break;
      case 3:
        _title = 'Favourite kiosks';
        _image = 'assets/images/multiple_markers.png';
        _nextHop = KioskScreen.routeName;
        _typeOfMainScreen = MainMenu.byFavorite;
        _titleOfScreen = 'Search favorite kiosk';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(_nextHop, arguments: {
            'type': _typeOfMainScreen,
            'title': _titleOfScreen,
          },);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    child: Image.asset(
                      _image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
