import 'package:authentications/core/commons/loading.dart';
import 'package:authentications/features/auth/controller/auth_controller.dart';
import 'package:authentications/features/home/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils.dart';

class EmailPassword extends ConsumerStatefulWidget {
  const EmailPassword({super.key});
  @override
  ConsumerState<EmailPassword> createState() => _EmailPasswordState();
}

class _EmailPasswordState extends ConsumerState<EmailPassword> {
  final hideProvider = StateProvider<bool>((ref) => true);
  final upProvider = StateProvider<bool>((ref) => true);
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).emailSignIn(
              email: email.text.trim(),
              password: password.text.trim(),
              context: context);
    }
  }
  Future<void> signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).emailSignUp(
              email: email.text.trim(),
              password: password.text.trim(),
              context: context);
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading=ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EmailPassword',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:isLoading?const Center(child: Loading()): Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
              width: width * 0.8,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: const InputDecoration(
                    hintText: 'Enter a valid E-Mail',
                    labelText: 'Email',
                    suffixIcon: Icon(Icons.email_outlined)),
                validator: (value) => validateEmail(value),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer(builder: (context1, ref, child) {
              bool hide = ref.watch(hideProvider);
              return SizedBox(
                height: height * 0.1,
                width: width * 0.8,
                child: TextFormField(
                  obscureText: hide,
                  controller: password,
                  decoration: InputDecoration(
                      hintText: 'Enter a strong Password',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(hide
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          ref.read(hideProvider.notifier).state = !hide;
                        },
                      )),
                  validator: (value) => validatePassword(value),
                ),
              );
            }),
            Consumer(builder: (context1, ref, child) {
              bool up = ref.watch(upProvider);
              return Column(
                children: [
                  up
                      ? ElevatedButton(
                          onPressed: ()=> signUp(context), child: const Text('SignUp'))
                      : ElevatedButton(
                          onPressed: ()=>signIn(context), child: const Text('SignIn')),
                  const SizedBox(
                    height: 20,
                  ),
                  up
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?,'),
                            TextButton(
                                onPressed: () {
                                  email.clear();
                                  password.clear();
                                  ref.read(upProvider.notifier).state = !up;
                                },
                                child: const Text('SignIn'))
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?,"),
                            TextButton(
                                onPressed: () {
                                  email.clear();
                                  password.clear();
                                  ref.read(upProvider.notifier).state = !up;
                                },
                                child: const Text('SignUp'))
                          ],
                        )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
