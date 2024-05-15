import 'package:barangqrcode/app/data/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  RxBool isLoading = false.obs;

  final ProductModel product = Get.arguments;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  void onInit() {
    codeC.text = product.code;
    nameC.text = product.nama;
    qtyC.text = '${product.qty}';
    super.onInit();
  }

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      await fireStore.collection('products').doc(data['id']).update({
        "nama": data['nama'],
        "qty": data['qty'],
      });
      return {
        'error': false,
        'message': 'Berhasil Update Product',
      };
    } catch (e) {
      print(e);
      return {
        'error': true,
        'message': 'Tidak dapat Update Product',
      };
    }
  }

  void updateProductProses() async {
    if (isLoading.isFalse) {
      if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
        isLoading(true);
        var hasil = await updateProduct({
          "id": product.productId,
          "nama": nameC.text,
          "qty": int.tryParse(qtyC.text) ?? 0,
        });
        isLoading(false);

        Get.snackbar(hasil['error'] ? 'Error' : 'Berhasil', hasil['message']);
      } else {
        Get.snackbar('Error', 'Semua Data Wajib Di Isi',
            duration: const Duration(seconds: 2));
      }
    }
  }
}
