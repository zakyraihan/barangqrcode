import 'package:barangqrcode/app/data/model/product_model.dart';
import 'package:barangqrcode/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

// pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '8.15.0'
class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductsView'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.stereamProducts(),
        builder: (context, snapProduct) {
          if (snapProduct.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapProduct.data!.docs.isEmpty) {
            return const Center(child: Text('No Products'));
          }

          List<ProductModel> allProducts = [];

          for (var e in snapProduct.data!.docs) {
            allProducts.add(ProductModel.fromJson(e.data()));
          }

          return ListView.builder(
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              ProductModel product = allProducts[index];
              return Container(
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(product.productId.toString()),
                  confirmDismiss: (direction) {
                    return Get.defaultDialog(
                      title: 'Delete Produk',
                      middleText: 'Apakah Kamu Yakin To Delete This Product',
                      actions: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteProductProses(
                                allProducts[index].productId);
                            Get.back();
                          },
                          child: Obx(
                            () => controller.isLoadingDelete.isFalse
                                ? const Text('Delete')
                                : Container(
                                    padding: const EdgeInsets.all(2),
                                    width: 15,
                                    height: 15,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PRODUCT, arguments: product);
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        height: 130,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.code,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(product.nama),
                                  Text('Jumlah : ${product.qty}'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: QrImageView(
                                data: product.code.toString(),
                                version: QrVersions.auto,
                                size: 200,
                                backgroundColor: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
