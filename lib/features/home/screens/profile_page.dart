import 'package:authentications/core/theme/palette.dart';
import 'package:authentications/features/auth/controller/auth_controller.dart';
import 'package:authentications/features/home/screens/home_page.dart';
import 'package:authentications/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel? user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(
              child: Text('Something went wrong'),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Palette.greyColor,
                    child: Icon(
                      Icons.person,
                      color: Palette.whiteColor,
                    ),
                  ),
                  Text(user.name),
                  Row(
                    children: [
                      Text(user.email),
                      Icon(
                        user.emailVerified
                            ? Icons.verified
                            : Icons.not_interested,
                        color: Palette.greyColor,
                      )
                    ],
                  ),
                  Text(user.phone),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!user.emailVerified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .emailVerification(context);
                            },
                            child: const Text('Send verification email')),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .verify();
                            },
                            child: const Text('"Refresh" ')),
                        const Text('If you verified your email')
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                      },
                      child: const Text('Sign Out'))
                ],
              ),
            ),
    );
  }
}
