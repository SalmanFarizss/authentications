import 'package:authentications/features/auth/screens/email_and_password.dart';
import 'package:flutter/material.dart';
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
            onPressed: () {},
            child:const Text('Phone Number'),
          ),
          ElevatedButton(
            onPressed: () {},
            child:const Text('Google'),
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
