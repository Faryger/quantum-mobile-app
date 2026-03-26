import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../../backend/api_client.dart';
import 'permises_list_model.dart';
export 'permises_list_model.dart';

class PermisesListWidget extends StatefulWidget {
  const PermisesListWidget({super.key});

  static String routeName = 'Permises_List';
  static String routePath = '/permisesList';

  @override
  State<PermisesListWidget> createState() => _PermisesListWidgetState();
}

class _PermisesListWidgetState extends State<PermisesListWidget> {
  late PermisesListModel _model;
  late Future<List<dynamic>> _permisosFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PermisesListModel());
    _permisosFuture = ApiClient.getPermissions();
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
            'Gestión de Permisos',
            style: TextStyle(fontFamily: 'Outfit', color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.w700),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: FutureBuilder<List<dynamic>>(
            future: _permisosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay permisos registrados', style: TextStyle(fontFamily: 'Readex Pro')));
              }

              final permisos = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: permisos.length,
                itemBuilder: (context, index) {
                  final permiso = permisos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF14B8A6).withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.edit_calendar_rounded, color: Color(0xFF14B8A6), size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Permiso #${permiso['id']}", style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                              Text("Tipo: ${permiso['permission_type'] ?? 'N/A'}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              Text("Desde: ${permiso['start_date']} | Hasta: ${permiso['end_date']}", style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: wrapWithModel(
          model: _model.navBarModel,
          updateCallback: () => setState(() {}),
          child: const NavBarWidget(currentPage: 'permisos'),
        ),
      ),
    );
  }
}
