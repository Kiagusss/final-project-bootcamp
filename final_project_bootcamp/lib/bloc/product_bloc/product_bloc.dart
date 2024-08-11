import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project_bootcamp/model/product_model.dart';
import 'dart:io';
import '../../services/repository/product_repository.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductLoading()) {
    on<LoadProducts>((event, emit) async {
      try {
        final products = productRepository.getProducts();
        await emit.forEach(products, onData: (products) {
          return ProductLoaded(products);
        });
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<AddProduct>((event, emit) async {
      try {
        await productRepository.addProduct(event.product, event.imageFile);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProduct>((event, emit) async {
      try {
        await productRepository.updateProduct(event.product, event.imageFile);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProduct>((event, emit) async {
      try {
        await productRepository.deleteProduct(event.productId);
        add(LoadProducts());
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
