import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/api_client.dart';
import 'asistencia_model.dart';
export 'asistencia_model.dart';

class AsistenciaWidget extends StatefulWidget {
  const AsistenciaWidget({super.key});

  static String routeName = 'asistencia';
  static String routePath = '/asistencia';

  @override
  State<AsistenciaWidget> createState() => _AsistenciaWidgetState();
}

class _AsistenciaWidgetState extends State<AsistenciaWidget> {
  late AsistenciaModel _model;
  late Future<List<dynamic>> _asistenciaFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AsistenciaModel());
    _asistenciaFuture = ApiClient.getAttendance();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd/MM/yy hh:mm a').format(dateTime);
    } catch (_) {
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            'Registro de Asistencia',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            color: const Color(0xFF14B8A6),
            onRefresh: () async {
              setState(() {
                _asistenciaFuture = ApiClient.getAttendance();
              });
            },
            child: FutureBuilder<List<dynamic>>(
              future: _asistenciaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aún no hay registros de asistencia', style: TextStyle(fontFamily: 'Readex Pro')));
                }

                final asistencias = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: asistencias.length,
                  itemBuilder: (context, index) {
                    final asistencia = asistencias[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFF14B8A6).withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.check_circle_rounded, color: Color(0xFF14B8A6), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Asistencia #${asistencia['id'] ?? 'N/A'}",
                                  style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Entrada: ${_formatDateTime(asistencia['check_in_time'])}",
                                  style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 12, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  "Salida: ${_formatDateTime(asistencia['departure_time'])}",
                                  style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 12, color: Color(0xFF64748B)),
                                ),
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
        ),
        bottomNavigationBar: wrapWithModel(
          model: _model.navBarModel,
          updateCallback: () => setState(() {}),
          child: const NavBarWidget(
            currentPage: 'asistencia',
          ),
        ),
      ),
    );
  }
}
