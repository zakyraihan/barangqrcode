import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  RxBool isLoading = false.obs;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      var hasil = await fireStore.collection('products').add(data);
      await fireStore
          .collection('products')
          .doc(hasil.id)
          .update({"productId": hasil.id});
      return {
        'error': false,
        'message': 'Berhasil Menambah Product',
      };
    } catch (e) {
      print(e);
      return {
        'error': true,
        'message': 'Tidak dapat Menambah Product',
      };
    }
  }

  void addProductProses() async {
    if (codeC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        qtyC.text.isNotEmpty) {
      isLoading(true);
      Map<String, dynamic> hasil = await addProduct({
        'code': codeC.text,
        'nama': nameC.text,
        'qty': int.tryParse(qtyC.text) ?? 0
      });
      isLoading(false);

      Get.back();

      Get.snackbar(
          hasil['error'] == true ? 'Error' : 'Succes', hasil['message']);
    } else {
      Get.snackbar('Error', 'Semua Data Wajib Di Isi');
    }
  }
}
