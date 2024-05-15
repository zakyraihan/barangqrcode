import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // untuk cek kondisi ada auth atau tidak -> uid
  // NULL -> tidak ada user yang sedang login
  // uid -> ada user yang sedang login
  String? uid;

  late FirebaseAuth auth;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return {
        'error': false,
        'message': 'Berhasil Login',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'error': true,
        'message': '${e.message}',
      };
    } catch (e) {
      // error general
      return {
        'error': true,
        'message': 'Tidak dapat Login',
      };
    }
  }

  Future<Map<String, dynamic>> logOut() async {
    try {
      await auth.signOut();
      return {
        'error': false,
        'message': 'Berhasil Log Out',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'error': true,
        'message': '${e.message}',
      };
    } catch (e) {
      // error general
      return {
        'error': true,
        'message': 'Tidak dapat Log Out',
      };
    }
  }

  @override
  void onInit() {
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });
    super.onInit();
  }
}
