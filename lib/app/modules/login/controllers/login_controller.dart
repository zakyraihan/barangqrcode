import 'package:barangqrcode/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool obscure = true.obs;
  RxBool isLoading = false.obs;
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final AuthController authC = Get.find<AuthController>();

  void isObscure() {
    obscure.value = !obscure.value;
  }

  loginProses() async {
    if (isLoading.isFalse) {
      if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
        isLoading(true);
        Map<String, dynamic> hasil =
            await authC.login(emailC.text, passwordC.text);
        isLoading(false);

        if (hasil['error'] == true) {
          Get.snackbar('Error', hasil['message']);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.snackbar('Error', 'email dan password wajib di isi');
      }
    }
  }

  logOutProses() async {
    Map<String, dynamic> hasil = await authC.logOut();
    if (hasil['error'] == false) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar('Error', hasil['message']);
    }
  }
}

