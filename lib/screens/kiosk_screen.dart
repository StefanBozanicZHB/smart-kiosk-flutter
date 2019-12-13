import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/widgets/kiosk_item_widget.dart';

class KioskScreen extends StatefulWidget {
  static const routeName = '/kiosk-screen';

  @override
  _KioskScreenState createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  Icon _cusIcon = Icon(Icons.search);
  Widget _cusSearchBar = Text('Kiosk sreach');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final routeArguments =
        ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final type = routeArguments['type'];
    final title = routeArguments['title'];

    return Scaffold(
      appBar: AppBar(
        title: _cusSearchBar,
        actions: <Widget>[
          IconButton(
              icon: _cusIcon,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  if (_cusIcon.icon == Icons.search) {
                    _cusIcon = Icon(Icons.cancel);
                    _cusSearchBar = TextField(
                      autofocus: true,
                      onChanged: (text) {
                        Provider.of<Kiosks>(context, listen: false)
                            .filteringKiosk(text, type);
                      },
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: title,
                        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  } else {
                    _cusIcon = Icon(Icons.search);
                    _cusSearchBar = const Text('Kiosk sreach');
                    Provider.of<Kiosks>(context, listen: false)
                        .returnAllKiosk();
                  }
                });
              }),
        ],
      ),
      body: FutureBuilder(
          future: !_isLoading
              ? Provider.of<Kiosks>(context, listen: false).fetchAndSetKiosks()
              : null,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return textOnCenter(content: 'An error occurred!');
              } else {
                return type != typeOfMainSceen.byFavorite
                    ? Consumer<Kiosks>(
                        builder: (ctx, kioskData, child) => kioskData
                                    .kiosks.length ==
                                0
                            ? textOnCenter()
                            : ListView.builder(
                                itemCount: kioskData.kiosks.length,
                                itemBuilder: (ctx, index) =>
                                    KioskItemWidget(kioskData.kiosks[index]),
                              ),
                      )
                    : Consumer<Kiosks>(
                  builder: (ctx, kioskData, child) => kioskData
                      .kiosksFavorite.length == 0
                      ? textOnCenter()
                      : ListView.builder(
                    itemCount: kioskData.kiosksFavorite.length,
                    itemBuilder: (ctx, index) =>
                        KioskItemWidget(kioskData.kiosksFavorite[index]),
                  ),
                );
              }
            }
          }),
    );
  }
}

Widget textOnCenter({String content = 'No Data!'}){
  return Center(
    child: Text(content),
  );
}
