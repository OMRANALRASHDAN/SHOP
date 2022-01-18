import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String tilte;
  // ProductDetailScreen(this.tilte);
  static const routeName = 'Detail-Screen';

  @override
  Widget build(BuildContext context) {
    final ProductId = ModalRoute.of(context).settings.arguments as String;
    final productData =
        Provider.of<Products>(context, listen: false).findById(ProductId);
    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                productData.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${productData.price}',
              style: TextStyle(fontSize: 20, color: Colors.grey ),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
               productData.description,
               textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
