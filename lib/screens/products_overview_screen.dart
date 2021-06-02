import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('myShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites)
                  {
                    _showOnlyFavorites = true;
                  }
                  else
                  {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: const Text('Only Favorites'),
                    value: FilterOptions.Favorites),
                PopupMenuItem(
                    child: const Text('Show All'), value: FilterOptions.All),
              ],
              icon: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                  child: ch!,
                  value: cart.itemCount != null ? cart.itemCount.toString() : '0',
                  ),
                child:
                IconButton(icon: Icon(Icons.shopping_cart,),
                onPressed: (){},),
                ),
          ],
        ),
        body: ProductsGrid(_showOnlyFavorites));
  }
}
