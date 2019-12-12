import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/screens/kiosk_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(4, (index) {
        return ItemMenu(index);
//            return ItemMainMenu(index);
      }),
    );
  }
}

class ItemMenu extends StatefulWidget {
  final index;

  ItemMenu(this.index);

  @override
  _ItemMenuState createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  String title;
  String image;
  String nextHop;

  @override
  void initState() {
    super.initState();
    switch (widget.index) {
      case 0:
        title = 'Nearest kiosks';
        image = 'assets/images/map_and_marker.png';
        nextHop = KioskScreen.routeName;
        break;
      case 1:
        title = 'Search kiosks by name or number';
        image = 'assets/images/marker_with_number.jpg';
        nextHop = KioskScreen.routeName;
        break;
      case 2:
        title = 'Search kiosk by street name';
        image = 'assets/images/street.png';
        nextHop = KioskScreen.routeName;
        break;
      case 3:
        title = 'Favourite kiosks';
        image = 'assets/images/multiple_markers.png';
        nextHop = KioskScreen.routeName;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(nextHop);
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
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
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
