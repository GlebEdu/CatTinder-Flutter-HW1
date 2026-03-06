import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cattinder_hw1/data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = GetIt.I.get<AuthService>();
    final ok = await auth.login(_usernameController.text.trim(), _passwordController.text);
    if (!mounted) return;
    setState(() { _loading = false; });
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() { _error = 'Неверный логин или пароль'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Войти')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Имя пользователя'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите имя пользователя' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (v) => (v == null || v.length < 6) ? 'Пароль минимум 6 символов' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null) Text(_error ?? '', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('Войти')),
            ],
          ),
        ),
      ),
    );
  }
}
