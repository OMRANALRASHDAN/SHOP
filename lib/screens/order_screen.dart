import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app-drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrderScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();

      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body:isLoading? Center(child: CircularProgressIndicator(),)  : ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(orders.orders[index]),
        itemCount: orders.orders.length,
      ),
    );
  }
}
