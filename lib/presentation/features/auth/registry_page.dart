import 'package:expanda/data/models/user_response.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/presentation/features/auth/auth_provider.dart';
import 'package:expanda/presentation/widgets/custom_button.dart';
import 'package:expanda/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistryPage extends StatelessWidget {
  static const String routeName = '/registry';

  const RegistryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta'), centerTitle: true),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: RegistryForm(),
        ),
      ),
    );
  }
}

///
///

class RegistryForm extends ConsumerStatefulWidget {
  const RegistryForm({super.key});

  @override
  ConsumerState<RegistryForm> createState() => _RegistryFormState();
}

class _RegistryFormState extends ConsumerState<RegistryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Gender? genderSelected;
  Role roleSelected = Role.user;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Nombre
          CustomTextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            label: 'Nombre',
            prefixIcon: const Icon(Icons.person_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Email
          CustomTextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu email';
              }
              /* if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Ingresa un email válido';
              } */
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Telefono
          CustomTextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            label: 'Telefono',
            prefixIcon: const Icon(Icons.phone_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu telefono';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SegmentedButton(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(label: Text('Estudiante'), value: Role.user),
                    ButtonSegment(label: Text('Profesor'), value: Role.teacher),
                  ],
                  selected: {roleSelected},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      roleSelected = newSelection.first;
                    });
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Campo de contraseña
          CustomTextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            label: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Botón de submit
          CustomButton(
            text: 'Registrarse',
            onPressed: _submit,
            isLoading: authState.isLoading,
          ),

          const SizedBox(height: 16),

          // Toggle entre login y registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Ya tienes cuenta?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () {
                  //ref.read(authProvider.notifier).clearError();
                },
                child: Text(
                  'Inicia sesión',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final role = roleSelected;
      final gender = genderSelected;

      final user = UserResponse(
        sessionId: '',
        email: email,
        name: name,
        phone: phone,
        role: role,
        gender: gender,
      );

      ref.read(authProvider.notifier).register(user, password);
    } else {
      print('Formulario no válido');
    }
  }
}
