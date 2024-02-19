import 'package:authentications/core/commons/loading.dart';
import 'package:authentications/features/auth/controller/auth_controller.dart';
import 'package:authentications/features/home/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class PhoneNumber extends ConsumerStatefulWidget {
  const PhoneNumber({super.key});

  @override
  ConsumerState<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends ConsumerState<PhoneNumber> {
  TextEditingController phone=TextEditingController(text:'+91');
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isLoading=ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Login',style:TextStyle(fontWeight: FontWeight.bold),),),
      body:isLoading?const Center(child:Loading(),): Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height*0.1,
              width: width*0.9,
              child: TextFormField(
                controller: phone,
                maxLength: 13,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone number',hintText: 'Enter your phone number'),
              ),
            ),
            ElevatedButton(onPressed:() {
              ref.read(authControllerProvider.notifier).phoneNumberSignIn(phone: phone.text.trim(), context: context);
            }, child:const Text('Get OTP') )
          ],
        ),
      ),
    );
  }
}
