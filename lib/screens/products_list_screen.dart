import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/providers/products.dart';
import 'package:smart_kiosk/providers/products.dart' as prefix0;
import 'package:smart_kiosk/widgets/product_item_widget.dart';

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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(text: 'CASH',),
            Tab(text: 'CARD',),
          ]),
          title: Text('${kiosk.name}'),
        ),
        body: TabBarView(
          children: <Widget>[
            cashWidget(kiosk.id, typeOfPaymentMethod.cash),
            cashWidget(kiosk.id, typeOfPaymentMethod.card),
          ],
        ),
      ),
    );
  }

  Widget cashWidget(kioskId, paymentMethod) {
    return FutureBuilder(
      future: !_isLoading ? _sendRequestForLoadingData(kioskId) : null,
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
            return paymentMethod == typeOfPaymentMethod.card
                ? Consumer<Products>(
                    builder: (ctx, produtsData, chield) => produtsData
                                .productsCard.length ==
                            0
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
                            itemCount: produtsData.productsCard.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) =>
                                ProductItemWidget(produtsData.productsCard[index]),
                          ),
                  )
                : Consumer<Products>(
                    builder: (ctx, produtsData, chield) => produtsData
                                .productsCash.length ==
                            0
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
                            itemCount: produtsData.productsCash.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) =>
                                ProductItemWidget(produtsData.productsCash[index]),
                          ),
                  );
          }
        }
      },
    );
  }
}
