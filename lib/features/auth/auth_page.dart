import 'package:expanda/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: AuthView(),
    );
  }
}

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (auth.email != null) Text('Welcome, ${auth.email}'),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(authProvider.notifier)
                  .login('test@example.com', 'password123');
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(authProvider.notifier)
                  .register('test@example.com', 'password123');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
