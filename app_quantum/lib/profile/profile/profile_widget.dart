import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../../backend/api_client.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  static String routeName = 'profile';
  static String routePath = '/profile';

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  String _username = 'Usuario';
  String _email = 'correo@ejemplo.com';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await ApiClient.getUserProfile();
      if (mounted) {
        setState(() {
          _username = data['login'] ?? 'Usuario';
          _email = data['email'] ?? 'correo@ejemplo.com';
        });
      }
    } catch (e) {
      // Fallback a locales si falla
      final name = await ApiClient.getUsername();
      final email = await ApiClient.getEmail();
      if (mounted) {
        setState(() {
          _username = name;
          _email = email;
        });
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Mi Cuenta',
            style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF1E293B), fontSize: 22, fontWeight: FontWeight.w800),
          ),
          elevation: 0,
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Avatar Section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage('https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=200&q=80'),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Color(0xFF14B8A6), shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Info Section
                      _ProfileInfoCard(label: 'Nombre de Usuario', value: _username, icon: Icons.person_outline_rounded),
                      const SizedBox(height: 16),
                      _ProfileInfoCard(label: 'Correo Electrónico', value: _email, icon: Icons.email_outlined),
                      const SizedBox(height: 16),
                      _ProfileInfoCard(label: 'Estado', value: 'Activo', icon: Icons.verified_user_outlined),
                      
                      const SizedBox(height: 48),
                      // Logout Button
                      FFButtonWidget(
                        onPressed: () async {
                          await ApiClient.logout();
                          if (context.mounted) context.goNamed('signIn');
                        },
                        text: 'Cerrar Sesión',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56,
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          textStyle: const TextStyle(fontFamily: 'Outfit', color: Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 16),
                          elevation: 0,
                          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            wrapWithModel(
              model: _model.navBarModel,
              updateCallback: () => setState(() {}),
              child: const NavBarWidget(currentPage: 'profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileInfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF64748B), size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
            ],
          ),
        ],
      ),
    );
  }
}
