import 'package:authentications/features/auth/controller/auth_controller.dart';
import 'package:authentications/features/auth/screens/email_and_password.dart';
import 'package:authentications/features/auth/screens/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
///globals
double height=0.0;
double width=0.0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Methods',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailPassword(),));
                },
                child:const Text('Email & Password'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneNumber(),));
            },
            child:const Text('Phone Number'),
          ),
          Consumer(
            builder:(context1, ref, child) => ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).googleSignIn(context);
              },
              child:SizedBox(
                height: height*0.04,
                width: width*0.5,
                child: Row(
                  children: [
                    const Text('SignIn with Google'),
                    const SizedBox(width: 5,),
                    Image.asset('assets/images/google.png'),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child:const Text('Facebook'),
          ),
        ],
      ),
    );
  }
}
