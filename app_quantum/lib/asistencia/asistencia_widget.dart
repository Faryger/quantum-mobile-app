import '/backend/supabase/database/tables/asistencia.dart';
import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late Future<List<AsistenciaRow>> _asistenciaFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AsistenciaModel());
    _asistenciaFuture = AsistenciaTable().queryRows(
      queryFn: (q) => q.order('entry_time', ascending: false),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A';
    }
    return DateFormat('dd/MM/yy hh:mm a').format(dateTime);
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
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _asistenciaFuture = AsistenciaTable().queryRows(
                  queryFn: (q) => q.order('entry_time', ascending: false),
                );
              });
            },
            child: FutureBuilder<List<AsistenciaRow>>(
              future: _asistenciaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Tus registros de entrada y salida aparecerán aquí.',
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final asistencias = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
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
                            'ID: ${asistencia.scannedId ?? 'Desconocido'}',
                            style: FlutterFlowTheme.of(context).titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrada: ${_formatDateTime(asistencia.entryTime)}',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Text(
                                'Salida: ${_formatDateTime(asistencia.exitTime)}',
                                style: FlutterFlowTheme.of(context).bodyMedium,
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
