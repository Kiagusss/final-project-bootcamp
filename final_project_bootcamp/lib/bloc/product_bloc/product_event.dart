part of "product_bloc.dart";

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;
  final File imageFile;

  const AddProduct(this.product, this.imageFile);

  @override
  List<Object> get props => [product, imageFile];
}


class UpdateProduct extends ProductEvent {
  final Product product;
  final File? imageFile;

  const UpdateProduct(this.product, this.imageFile);

  @override
  List<Object> get props => [product, imageFile ?? Object()]; 
}



class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}
