import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

import '../../model/product_model.dart';



class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addProduct(Product product, File imageFile) async {
    try {
 
      String fileName = basename(imageFile.path);
      Reference ref = _storage.ref().child('products/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('products').add({
        'name': product.name,
        'stock': product.stock,
        'category': product.category,
        'price': product.price,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> updateProduct(Product product, File? imageFile) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
      
        String fileName = basename(imageFile.path);
        Reference ref = _storage.ref().child('products/$fileName');
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

     
      await _firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'stock': product.stock,
        'category': product.category,
        'price': product.price,
        'imageUrl': imageUrl ?? product.imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
