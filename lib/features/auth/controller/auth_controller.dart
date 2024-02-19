import 'package:authentications/core/providers/firebase_providers.dart';
import 'package:authentications/features/auth/repository/auth_repository.dart';
import 'package:authentications/features/home/screens/profile_page.dart';
import 'package:authentications/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final authRepositoryProvider = Provider((ref) => AuthRepository(
    fireStore: ref.read(fireStoreProvider), auth: ref.read(authProvider)));
final authControllerProvider =
    NotifierProvider<AuthController, bool>(() => AuthController());

class AuthController extends Notifier<bool> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  @override
  bool build() {
    return false;
  }

  ///email&password
  Future<void> emailSignUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    var res = await _repository.emailSignUp(email: email, password: password);
    state = false;
    res.fold((l) => failureSnackBar(context, l.failure), (r) {
      if (r != null) {
        ref.read(userProvider.notifier).update((state) => r);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ));
        successSnackBar(context, 'User signup successful');
      } else {
        failureSnackBar(context, 'User signup Failed');
      }
    });
  }

  Future<void> emailSignIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    var res = await _repository.emailSignIn(email: email, password: password);
    state = false;
    res.fold((l) => failureSnackBar(context, l.failure), (r) {
      if (r != null) {
        ref.read(userProvider.notifier).update((state) => r);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ));
        successSnackBar(context, 'Login successful');
      } else {
        failureSnackBar(context, 'Login Failed');
      }
    });
  }

  Future<void> emailVerification(BuildContext context) async {
    state = true;
    var res = await _repository.emailVerification();
    state = false;
    res.fold((l) => failureSnackBar(context, l.failure),
        (r) => successSnackBar(context, r));
  }

  Future<void> phoneNumberSignIn(
      {required String phone, required BuildContext context}) async {
    state = true;
    var res = await _repository.phoneNumberSignIn(phone: phone, context: context);
    state = false;
    res.fold((l) => failureSnackBar(context,l.failure), (r) {
      // if(r=='ok'){
      //   successSnackBar(context,'Login Successful');
      //   ref.read(userProvider.notifier).update((state) => UserModel(name: '', email: '', emailVerified: false, phone: phone, id: ''));
      //   Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ProfilePage(),));
      // }else{
      //   failureSnackBar(context, 'something went wrong');
      // }
      successSnackBar(context, r);
    });
  }

  ///google SignIn
  Future<void> googleSignIn(BuildContext context) async {
    state = true;
    var res = await _repository.googleSignIn();
    state = false;
    res.fold((l) => failureSnackBar(context, l.failure), (r) {
      if (r != null) {
        ref.read(userProvider.notifier).update((state) => r);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ));
        successSnackBar(context, 'User signup successful');
      } else {
        failureSnackBar(context, 'User signup Failed');
      }
    });
  }

  ///signOut
  Future<void> signOut() async {
    await _repository.signOut();
  }

  Future<void> verify() async {
    state = true;
    bool a = await _repository.verify();
    state = false;
    ref
        .read(userProvider.notifier)
        .update((state) => state!.copyWith(emailVerified: a));
  }
}
