import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  RxBool isLoadingDelete = false.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> stereamProducts() async* {
    yield* fireStore.collection('products').snapshots();
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      await fireStore.collection('products').doc(id).delete();
      return {
        'error': false,
        'message': 'Berhasil delete Product',
      };
    } catch (e) {
      print(e);
      return {
        'error': true,
        'message': 'Tidak dapat delete Product',
      };
    }
  }

  void deleteProductProses(String id) async {
    isLoadingDelete(true);
    Map<String, dynamic> hasil = await deleteProduct(id);
    Get.snackbar(hasil['error'] == true ? 'Error' : 'Succes', hasil['message']);
    Get.back();
    isLoadingDelete(false);
  }
}
