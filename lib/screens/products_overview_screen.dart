import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

Future<void> _refreshProducts(BuildContext context) async {
  await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit)
      {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Products>(context).fetchAndSetProducts().then((_) {
          _isLoading = false;
        });
      }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                  value: cart.itemCount.toString(),
                  ),
                child:
                IconButton(icon: Icon(Icons.shopping_cart,),
                onPressed: (){
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },),
                ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading ? Center(child: CircularProgressIndicator(),) :
        RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: ProductsGrid(_showOnlyFavorites)));
  }
}
