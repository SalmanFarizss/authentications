import 'package:authentications/core/providers/firebase_providers.dart';
import 'package:authentications/features/auth/repository/auth_repository.dart';
import 'package:authentications/features/home/screens/profile_page.dart';
import 'package:authentications/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils.dart';

final userProvider = StateProvider<UserModel?>((ref)=>null);
final authRepositoryProvider = Provider((ref)=>AuthRepository(fireStore: ref.read(fireStoreProvider), auth: ref.read(authProvider)));
final authControllerProvider = NotifierProvider<AuthController,bool>(()=>AuthController());

class AuthController extends Notifier<bool>{
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  @override
  bool build() {
    return false;
  }
  ///email&password
  Future<void> emailSignUp({required String email,required String password,required BuildContext context}) async {
    state=true;
    var res=await _repository.emailSignUp(email:email, password: password);
    state=false;
    res.fold((l) => failureSnackBar(context,l.failure), (r) {
      ref.read(userProvider.notifier).update((state) => r);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>const ProfilePage(),));
      successSnackBar(context, 'Login successful');
    });
  }
  Future<void> emailSignIn({required String email,required String password,required BuildContext context}) async {
    state=true;
    var res=await _repository.emailSignIn(email:email, password: password);
    state=false;
    res.fold((l) => failureSnackBar(context,l.failure), (r) {
      ref.read(userProvider.notifier).update((state) => r);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>const ProfilePage(),));
      successSnackBar(context, 'Login successful');
    });
  }
  ///signOut
  Future<void> signOut() async {
    await _repository.signOut();
  }
  }