import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/api_client.dart';
import '../../home/home_page/home_page_widget.dart';
import '../sign_up/sign_up_widget.dart';
import 'sign_in_model.dart';
export 'sign_in_model.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  static String routeName = 'signIn';
  static String routePath = '/signIn';

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  late SignInModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignInModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _model.textController1.text.trim();
    final password = _model.textController2.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tus credenciales')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6))),
      );
      
      await ApiClient.login(email, password);
      if (mounted) {
        Navigator.pop(context); // Close loading
        context.goNamed(HomePageWidget.routeName);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEF4444),
            content: Text('Error: Credenciales incorrectas o servidor caído'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Bienvenido de nuevo',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicia sesión para gestionar tus actividades.',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Username Field
                  const Text('Usuario', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _model.textController1!,
                    focusNode: _model.textFieldFocusNode1!,
                    hintText: 'Ej. juan.perez',
                    icon: Icons.person_outline_rounded,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Password Field
                  const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _model.textController2!,
                    focusNode: _model.textFieldFocusNode2!,
                    hintText: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Login Button
                  FFButtonWidget(
                    onPressed: _handleLogin,
                    text: 'Iniciar Sesión',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56,
                      color: const Color(0xFF14B8A6),
                      textStyle: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          prefixIcon: Icon(icon, color: const Color(0xFF14B8A6), size: 20),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: const Color(0xFF94A3B8)),
            onPressed: onToggleVisibility,
          ) : null,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: const TextStyle(fontFamily: 'Outfit', color: Color(0xFF1E293B)),
      ),
    );
  }
}
