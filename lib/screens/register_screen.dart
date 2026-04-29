import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

// CU-01 móvil: Registro de cliente
// Esta pantalla registra únicamente usuarios con rol "cliente"
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _celularController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      _nombreController.text,
      _correoController.text,
      _passwordController.text,
      _celularController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Error al registrar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crea tu cuenta',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Únete a nuestra plataforma de auxilio mecánico.'),
                const SizedBox(height: 40),

                _buildLabel('Nombre Completo'),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(hintText: 'Juan Pérez', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Correo Electrónico'),
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'correo@ejemplo.com', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Celular'),
                TextFormField(
                  controller: _celularController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '76543210', prefixIcon: Icon(Icons.phone_android_outlined)),
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),

                _buildLabel('Contraseña'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: '••••••••', prefixIcon: Icon(Icons.lock_outline)),
                  validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
                  child: isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Registrarme ahora'),
                ),
                
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Inicia sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}
