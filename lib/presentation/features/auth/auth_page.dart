import 'package:expanda/presentation/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final authState = ref.watch(authProvider);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (authState.isLoading) const CircularProgressIndicator(),

          if (authState.isAuthenticated)
            Text('Welcome, ${authState.user?.email ?? 'no email'}'),

          if (!authState.isAuthenticated)
            const Text('Please log in or register'),

          if ((authState.error ?? '').isNotEmpty)
            Text('Error: ${authState.error}'),

          ElevatedButton(
            onPressed: () async {
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
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('logout'),
          ),
        ],
      ),
    );
  }
}
