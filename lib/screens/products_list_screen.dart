import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/badge.dart';
import 'package:smart_kiosk/models/kiosk.dart';
import 'package:smart_kiosk/models/product.dart';
import 'package:smart_kiosk/providers/cart.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/providers/products.dart';
import 'package:smart_kiosk/screens/cart_screen.dart';
import 'package:smart_kiosk/screens/first_screen.dart';
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
    Kiosk _kiosk = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            const Tab(text: 'CASH',),
            const Tab(text: 'CARD',),
          ]),
          title: Text('${_kiosk.name}'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.cartCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(FirstScreen.routeName, arguments: CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            cashWidget(_kiosk.id, PaymentMethod.cash),
            cashWidget(_kiosk.id, PaymentMethod.card),
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
            return const Center(
              child: Text('An error occurred!'),
            );
          } else {
            return paymentMethod == PaymentMethod.card
                ? Consumer<Products>(
                    builder: (ctx, produtsData, chield) => produtsData
                                .productsCard.length ==
                            0
                        ? const Center(
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
                        ? const Center(
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
