import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/providers/products.dart';
import 'package:smart_kiosk/widgets/Product_item_widget.dart';

class ProductsListScreen extends StatefulWidget {
  static const routeName = '/products-list';

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  bool _isLoading = false;
  
  Future<void> _sendRequestForLoadingData(kioskId) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(kioskId);
//    setState(() {
//      _isLoading = true;
//    });
  }

  @override
  Widget build(BuildContext context) {
    KioskItem kiosk = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ]),
          title: Text('${kiosk.name}'),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: !_isLoading ? _sendRequestForLoadingData(kiosk.id) : null,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Products>(
                      builder: (ctx, produtsData, chield) =>
                          produtsData.products.length == 0
                              ? Center(
                                  child: Text('No Products'),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    childAspectRatio: 0.8,
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3,
                                  ),
                                  itemCount: produtsData.products.length,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (ctx, index) =>
                                      ProductItemWidget(
                                          produtsData.products[index]),
                                ),
                    );
                  }
                }
              },
            ),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
