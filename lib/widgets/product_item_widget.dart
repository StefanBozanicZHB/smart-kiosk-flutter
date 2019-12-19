import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
import 'package:smart_kiosk/models/product.dart';
import 'package:smart_kiosk/providers/cart.dart';
import 'package:smart_kiosk/providers/kiosks.dart';
import 'package:smart_kiosk/widgets/image_widget.dart';

class ProductItemWidget extends StatelessWidget {
  final Product _product;

  ProductItemWidget(this._product);

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);
    final _kiosk = Provider.of<Kiosks>(context, listen: false).currentKiosk;
    int _quantityInCart = _cart.countProductInCart(_product, _kiosk);

    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: ImageWidget(
                imageUrl: _product.pictureUrl,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Text(
                  '${_product.price} RSD',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.1, 0.2, 0.5, 0.9],
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(.2),
                      Colors.white.withOpacity(.6),
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: _quantityInCart == 0
                          ? null
                          : () {
                              _quantityInCart--;
                              _cart.detractCart(_product.id, _quantityInCart);
                            },
                      iconSize: 35,
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                    ),
                    IconButton(
                      onPressed: () {},
                      iconSize: 35,
                      icon: const Icon(Icons.shopping_cart),
                      color: Colors.red,
                    ),
                    IconButton(
                      onPressed: () {
                        _quantityInCart++;
                        try {
                          _cart.addInCart(_product, _kiosk, _quantityInCart);
                        } on HttpException catch (error) {
                          _showSnackBar(context, error);
                        } catch (error) {
                          _showSnackBar(context, error);
                        }
                      },
                      iconSize: 35,
                      icon: const Icon(Icons.add_circle),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            if (_quantityInCart != 0)
              Positioned(
                top: 49,
                right: 10,
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0)),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  padding:
                      new EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 2),
                  child: Text(
                    '$_quantityInCart',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              right: 50,
              left: 0,
              child: Container(
                color: Colors.black45,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Text(
                  '${_product.name}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  softWrap: true,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showSnackBar(context, content) {
    Scaffold.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(content: Text('$content'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}


