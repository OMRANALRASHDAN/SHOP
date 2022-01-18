import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import '../widgets/app-drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _DiscribtionFocusNode = FocusNode();
  final _ImageUrlFocusNode = FocusNode();

  var ImagUrlControler = TextEditingController();
  final _form = GlobalKey<FormState>();
  var EditProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);
  var isInit = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var isLoading = false;

  @override
  void initState() {
    _ImageUrlFocusNode.addListener(_updateImagrURL);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        EditProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': EditProduct.title,
          'description': EditProduct.description,
          'price': EditProduct.price.toString(),
          'imageUrl': ''
        };
        ImagUrlControler.text = EditProduct.imageUrl;
      }
    }

    isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ImageUrlFocusNode.removeListener(_updateImagrURL);
    _ImageUrlFocusNode.dispose();

    _priceFocusNode.dispose();
    _DiscribtionFocusNode.dispose();
    ImagUrlControler.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _updateImagrURL() {
    if (!_ImageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) return;
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (EditProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(EditProduct.id, EditProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(EditProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred'),
                  content: Text(error.toString()),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    //    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product '),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: InputDecoration(labelText: 'Titel'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        EditProduct = new Product(
                            isFavorite: EditProduct.isFavorite,
                            id: EditProduct.id,
                            title: value,
                            description: EditProduct.description,
                            imageUrl: EditProduct.imageUrl,
                            price: EditProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'please provide a value';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_DiscribtionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Price';
                        if (double.tryParse(value) == null)
                          return 'Please Enter a Valid Number';
                        if (double.parse(value) <= 0)
                          return 'Please Enter a Number greater then zero';
                        return null;
                      },
                      onSaved: (value) {
                        EditProduct = new Product(
                            isFavorite: EditProduct.isFavorite,
                            id: EditProduct.id,
                            title: EditProduct.title,
                            description: EditProduct.description,
                            imageUrl: EditProduct.imageUrl,
                            price: double.parse(value));
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration: InputDecoration(labelText: 'Discription'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _DiscribtionFocusNode,
                      onSaved: (value) {
                        EditProduct = new Product(
                            isFavorite: EditProduct.isFavorite,
                            id: EditProduct.id,
                            title: EditProduct.title,
                            description: value,
                            imageUrl: EditProduct.imageUrl,
                            price: EditProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Discription';
                        if (value.length <= 10)
                          return 'Should be at least 10 caracter';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: ImagUrlControler.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(ImagUrlControler.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: ImagUrlControler,
                            onSaved: (value) {
                              EditProduct = new Product(
                                  isFavorite: EditProduct.isFavorite,
                                  id: EditProduct.id,
                                  title: EditProduct.title,
                                  description: EditProduct.description,
                                  imageUrl: value,
                                  price: EditProduct.price);
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please Enter a Image URL.';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'pleas Enter a valid URL.';
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _saveForm();
                            },
                            focusNode: _ImageUrlFocusNode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
