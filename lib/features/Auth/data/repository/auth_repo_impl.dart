import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fruit_app/features/Auth/domain/repository/auth_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<dynamic> completeInformation({
    String? name,
    String? phoneNumber,
    String? address,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'phone': phoneNumber,
      'address': address,
      'isProfileComplete': true,
    }, SetOptions(merge: true));
  }

  @override
  Future<dynamic> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isProfileComplete': false,
      });
    }

    return userCredential;
  }

  @override
  Future<dynamic> loginWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // التحقق من أن المستخدم لم يلغ عملية تسجيل الدخول
    if (loginResult.accessToken == null) {
      throw Exception('فشل تسجيل الدخول عبر فيسبوك');
    }
    // Create a credential from the access token
    else {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }
  }

  @override
  Future<dynamic> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null; // المستخدم لغى العملية
    } else {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print('Google Sign-In UID: ${userCredential.user?.uid}');

      return userCredential;
    }
  }
}
