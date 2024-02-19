import 'package:authentications/core/constants/firebase_constants.dart';
import 'package:authentications/core/failure.dart';
import 'package:authentications/core/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/typedef.dart';
import '../../../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;
  AuthRepository(
      {required FirebaseFirestore fireStore, required FirebaseAuth auth})
      : _fireStore = fireStore,
        _auth = auth;
  CollectionReference get _users => _fireStore.collection(FirebaseConstants.userCollection);

  ///email&password
  FutureEither<UserModel?> emailSignUp(
      {required String email, required String password}) async {
    try {
      UserModel? userModel;
       await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((value) {
            if(value.user!=null) {
              userModel= UserModel(
                name: value.user!.displayName ?? '',
                email: value.user!.email ?? '',
                emailVerified: value.user!.emailVerified,
                phone: value.user!.phoneNumber ?? '',
                profile: '',
                id: value.user!.uid,
              );
              _users.doc(value.user!.uid).set(userModel!.toJson());
            }
      });
      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code.isNotEmpty) {
        return left(Failure(failure: e.code));
      }
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }

  FutureEither<UserModel?> emailSignIn({required String email, required String password}) async {
    try {
      UserModel? userModel;
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        if(value.user!=null){
          DocumentSnapshot userDoc=await _users.doc(value.user!.uid).get();
          if(userDoc.exists){
            userModel=UserModel.fromJson(userDoc.data() as Map<String,dynamic>);
          }else{
            throw "User data corresponding to this email doesn't exists";
          }
        }
      });
      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code.isNotEmpty) {
        return left(Failure(failure: e.code));
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
      if (e.code.isNotEmpty) {
        return left(Failure(failure: e.code));
      }
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }

  Future<bool> verify() async {
    return _auth.currentUser!.emailVerified;
  }

  ///phoneNumber
  FutureEither<String> phoneNumberSignIn(
      {required String phone, required BuildContext context}) async {
    TextEditingController otp = TextEditingController();
    try {
     // if(kIsWeb){
     //   ConfirmationResult result=await _auth.signInWithPhoneNumber(phone);
     //    showOtpDialog(
     //       context: context,
     //       otp: otp,
     //       onPressed: () async {
     //         PhoneAuthCredential credential = PhoneAuthProvider.credential(
     //             verificationId: result.verificationId, smsCode: otp.text.trim());
     //         await _auth.signInWithCredential(credential);
     //         Navigator.of(context).pop();
     //       });
     // }else{
       await _auth.verifyPhoneNumber(
         phoneNumber: phone,
         verificationCompleted: (phoneAuthCredential) async {
           await _auth.signInWithCredential(phoneAuthCredential) ;
         },
         verificationFailed: (error) async {
           failureSnackBar(context, error.message.toString());
         },
         codeSent: (verificationId, forceResendingToken) async {
           await showOtpDialog(
               context: context,
               otp: otp,
               onPressed: () async {
                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
                     verificationId: verificationId, smsCode: otp.text.trim());
                 await _auth.signInWithCredential(credential);
                 Navigator.of(context).pop();
               });
         },
         codeAutoRetrievalTimeout: (verificationId) {},
       );
     // }
      return right('Success');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(failure: e.toString()));
    }
  }
  ///google SignIn
  FutureEither<UserModel?> googleSignIn()async{
    try {
      UserModel? userModel;
      GoogleSignInAccount? googleAccount=await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth=await googleAccount?.authentication;
      if(googleAuth?.accessToken!=null&&googleAuth?.idToken!=null){
        AuthCredential credential=GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken,idToken: googleAuth?.idToken);
        UserCredential userCredential=await _auth.signInWithCredential(credential);
        if(userCredential.user!=null){
          if(userCredential.additionalUserInfo!.isNewUser){
             userModel= UserModel(
              name: userCredential.user!.displayName ?? '',
              email: userCredential.user!.email ?? '',
              emailVerified:userCredential.user!.emailVerified,
              phone: userCredential.user!.phoneNumber ?? '',
              profile:userCredential.user!.photoURL??'',
              id:userCredential.user!.uid,
            );
            await _users.doc(userCredential.user!.uid).set(userModel.toJson());
          }else{
            DocumentSnapshot userDoc=await _users.doc(userCredential.user!.uid).get();
            if(userDoc.exists){
              userModel=UserModel.fromJson(userDoc.data() as Map<String,dynamic>);
            }else{
              throw 'User details about this account not found...!';
            }
          }
        }else{
          print('gggggggggggg');
        }
      }
      return right(userModel);
    }on FirebaseAuthException catch(error){
      throw error.message!;
    }catch(e){
      return left(Failure(failure: e.toString()));
    }
  }
  ///signOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
