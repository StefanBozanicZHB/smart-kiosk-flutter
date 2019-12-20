import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/kiosk.dart';
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

  int indexMain = 0;

  @override
  Widget build(BuildContext context) {
    final _routeArguments =
        ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final _type = _routeArguments['type'];
    final _title = _routeArguments['title'];

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
                            .filteringKiosk(text, _type);
                      },
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _title,
                        hintStyle:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return textOnCenter(content: 'An error occurred!');
              } else {
                return _type != MainMenu.byFavorite
                    ? Consumer<Kiosks>(
                        builder: (ctx, kioskData, child) =>
                            kioskData.kiosks.length == 0
                                ? textOnCenter()
                                : AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: kioskData.kiosks.length,
                                      itemBuilder: (ctx, index) =>
                                          AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: AdditionalFunctions
                                            .DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS,
                                        child: SlideAnimation(
                                          verticalOffset: AdditionalFunctions
                                              .VERTICAL_OFF_SET_ANIMATION,
                                          child: ScaleAnimation(
                                            child: KioskItemWidget(
                                                kioskData.kiosks[index]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      )
                    : Consumer<Kiosks>(
                        builder: (ctx, kioskData, child) => kioskData
                                    .kiosksFavorite.length ==
                                0
                            ? textOnCenter()
                            : AnimationLimiter(
                                child: ListView.builder(
                                  itemCount: kioskData.kiosksFavorite.length,
                                  itemBuilder: (ctx, index) =>
                                      AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: AdditionalFunctions
                                        .DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS,
                                    child: SlideAnimation(
                                      verticalOffset: AdditionalFunctions
                                          .VERTICAL_OFF_SET_ANIMATION,
                                      child: ScaleAnimation(
                                        child: KioskItemWidget(
                                            kioskData.kiosksFavorite[index]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      );
              }
            }
          }),
    );
  }

  Widget textOnCenter({String content = 'No Data!'}) {
    return Center(
      child: Text(content),
    );
  }
}
