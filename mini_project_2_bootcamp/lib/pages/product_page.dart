import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import '../bloc/product_bloc/product_bloc.dart';
import '../model/product_model.dart';
import '../shared/style.dart';
import 'widgets/custom_drawer.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadProductEvent());
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'STORE',
            style: title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: whiteColor,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TabItem('Fashion'),
                  TabItem('Shoes'),
                  TabItem('Food'),
                  TabItem('Electronic'),
                  TabItem('Sport'),
                ],
              ),
            ),
          ),
        ),
        drawer: CustomDrawer(),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoadedState) {
              var data = state.products;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: MasonryGridView.builder(
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var product = data[index] as ProductModel;
                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                            width: 5.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.network(
                              product.image,
                              height: 150,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(height: 10),
                            Text(
                              product.title,
                              style: title,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            Text(
                              product.description,
                              style: subtitle.copyWith(
                                  fontSize: 14, color: Colors.grey[600]),
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '\$${product.price}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber),
                                    SizedBox(width: 2),
                                    Text(
                                      product.rating.rate.toString(),
                                      style: TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            } else if (state is ProductErrorState) {
              return const Center(child: Text('Failed to fetch cart'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Container TabItem(String nameTab) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Tab(
        child: Text(
          nameTab,
          style: title.copyWith(color: whiteColor),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
