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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Registro de Asistencia',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Lato',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _asistenciaFuture = ApiClient.getAttendance();
              });
            },
            child: FutureBuilder<List<dynamic>>(
              future: _asistenciaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 90,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            'Aún no hay registros',
                            style: FlutterFlowTheme.of(context).titleLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final asistencias = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: asistencias.length,
                  itemBuilder: (context, index) {
                    final asistencia = asistencias[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            "User Data ID: \${asistencia['user_data_id'] ?? 'N/A'}",
                            style: FlutterFlowTheme.of(context).titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Entrada: \${_formatDateTime(asistencia['check_in_time'])}",
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                "Salida: \${_formatDateTime(asistencia['departure_time'])}",
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                "Estado: \${asistencia['status'] ?? 'N/A'}",
                                style: FlutterFlowTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                        ),
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
          child: NavBarWidget(
            currentPage: 'asistencia',
          ),
        ),
      ),
    );
  }
}
