import 'package:authentications/core/constants/firebase_constants.dart';
import 'package:authentications/core/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/typedef.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;
  AuthRepository(
      {required FirebaseFirestore fireStore, required FirebaseAuth auth})
      : _fireStore = fireStore,
        _auth = auth;
  CollectionReference get _users =>
      _fireStore.collection(FirebaseConstants.userCollection);

  ///email&password
  FutureEither<UserModel> emailSignUp(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(UserModel(
          name: credential.user!.displayName ?? '',
          email: credential.user!.email ?? '',
          emailVerified: credential.user!.emailVerified,
          phone: credential.user!.phoneNumber ?? '',
          id: credential.user!.uid,));
    } on FirebaseException catch (e) {
      if(e.code.isNotEmpty){
        return left(Failure(failure:e.code));
      }
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }
  FutureEither<UserModel> emailSignIn(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(UserModel(
          name: credential.user!.displayName ?? '',
          email: credential.user!.email ?? '',
          emailVerified: credential.user!.emailVerified,
          phone: credential.user!.phoneNumber ?? '',
          id: credential.user!.uid));
    } on FirebaseException catch (e) {
      if(e.code.isNotEmpty){
        return left(Failure(failure:e.code));
      }
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }
  FutureEither<String> emailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      return right('Verification Email send to your email, Check your email');
    } on FirebaseException catch (e) {
      if(e.code.isNotEmpty){
        return left(Failure(failure:e.code));
      }
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }
  ///signOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
  ///verified
  Future<bool> verify()async{
    return _auth.currentUser!.emailVerified;
  }
}
