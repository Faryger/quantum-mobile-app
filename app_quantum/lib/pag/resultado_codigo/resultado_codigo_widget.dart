import '/backend/supabase/database/tables/asistencia.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/index.dart';
import 'resultado_codigo_model.dart';
export 'resultado_codigo_model.dart';

class ResultadoCodigoWidget extends StatefulWidget {
  const ResultadoCodigoWidget({
    super.key,
    this.scannedCode,
  });

  final String? scannedCode;

  static String routeName = 'resultadoCodigo';
  static String routePath = '/resultadoCodigo';

  @override
  State<ResultadoCodigoWidget> createState() => _ResultadoCodigoWidgetState();
}

class _ResultadoCodigoWidgetState extends State<ResultadoCodigoWidget> {
  late ResultadoCodigoModel _model;
  String _messageTitle = 'Procesando...';
  String _messageSubtitle = '';
  IconData _messageIcon = Icons.hourglass_empty;
  Color _messageIconColor = Colors.grey;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResultadoCodigoModel());
    _processScannedCode();
  }

  Future<void> _processScannedCode() async {
    final code = widget.scannedCode ?? '';
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(Duration(days: 1));

    final asistenciaTable = AsistenciaTable();
    String registrationId = code.replaceAll('entrada', '').replaceAll('salida', '').trim();

    if (code.toLowerCase().contains('entrada')) {
      // Check for existing entry today
      final existingEntries = await asistenciaTable.queryRows(
        queryFn: (q) => q
            .eq('scanned_id', registrationId)
            .gte('entry_time', todayStart.toIso8601String())
            .lt('entry_time', todayEnd.toIso8601String()),
      );

      if (existingEntries.isNotEmpty) {
        setState(() {
          _messageTitle = 'Entrada ya registrada';
          _messageSubtitle = 'Ya has registrado tu entrada el día de hoy.';
          _messageIcon = Icons.warning_amber_rounded;
          _messageIconColor = Colors.orange;
        });
        return;
      }

      // Insert new entry
      try {
        await asistenciaTable.insert({
          'scanned_id': registrationId,
          'entry_time': now.toIso8601String(),
        });
        setState(() {
          _messageTitle = 'Entrada Registrada';
          _messageSubtitle =
              '${DateFormat('EEEE, d \'de\' MMMM', 'es_ES').format(now)} a las ${DateFormat('h:mm a').format(now)}';
          _messageIcon = Icons.check_rounded;
          _messageIconColor = Color(0xFF4CAF50);
        });
      } catch (e) {
        setState(() {
          _messageTitle = 'Error';
          _messageSubtitle = 'No se pudo registrar la entrada.';
          _messageIcon = Icons.error_outline;
          _messageIconColor = Colors.red;
        });
      }
    } else if (code.toLowerCase().contains('salida')) {
      // Find open entry for today
      final entriesToUpdate = await asistenciaTable.queryRows(
        queryFn: (q) => q
            .eq('scanned_id', registrationId)
            .gte('entry_time', todayStart.toIso8601String())
            .lt('entry_time', todayEnd.toIso8601String())
            .is_('exit_time', null),
        limit: 1,
      );

      if (entriesToUpdate.isNotEmpty) {
        final entryToUpdate = entriesToUpdate.first;
        try {
          await asistenciaTable.update(
            data: {'exit_time': now.toIso8601String()},
            matchingRows: (q) => q.eq('id', entryToUpdate.id),
          );
          setState(() {
            _messageTitle = 'Salida Registrada';
            _messageSubtitle =
                '${DateFormat('EEEE, d \'de\' MMMM', 'es_ES').format(now)} a las ${DateFormat('h:mm a').format(now)}';
            _messageIcon = Icons.check_rounded;
            _messageIconColor = Color(0xFF4CAF50);
          });
        } catch (e) {
          setState(() {
            _messageTitle = 'Error';
            _messageSubtitle = 'No se pudo registrar la salida.';
            _messageIcon = Icons.error_outline;
            _messageIconColor = Colors.red;
          });
        }
      } else {
         // Check if they already clocked out
        final alreadyExitedEntries = await asistenciaTable.queryRows(
          queryFn: (q) => q
              .eq('scanned_id', registrationId)
              .gte('entry_time', todayStart.toIso8601String())
              .lt('entry_time', todayEnd.toIso8601String())
              .not()
              .is_('exit_time', null),
        );

        if (alreadyExitedEntries.isNotEmpty) {
           setState(() {
            _messageTitle = 'Salida ya registrada';
            _messageSubtitle = 'Ya has registrado tu salida el día de hoy.';
            _messageIcon = Icons.warning_amber_rounded;
            _messageIconColor = Colors.orange;
          });
        } else {
           setState(() {
            _messageTitle = 'Sin entrada previa';
            _messageSubtitle = 'No se encontró una entrada registrada para hoy.';
            _messageIcon = Icons.error_outline;
            _messageIconColor = Colors.red;
          });
        }
      }
    } else {
       setState(() {
        _messageTitle = 'Código QR no válido';
        _messageSubtitle = 'El código no contiene "entrada" o "salida".';
        _messageIcon = Icons.error_outline;
        _messageIconColor = Colors.red;
      });
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
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF121929),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        color: Color(0x1AFFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _messageIconColor,
                          width: 3.0,
                        ),
                      ),
                      child: Icon(
                        _messageIcon,
                        color: _messageIconColor,
                        size: 80.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        _messageTitle,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .displaySmall
                            .override(
                              fontFamily: 'Lato',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _messageSubtitle,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Lato',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.goNamed(HomePageWidget.routeName);
                  },
                  text: 'Finalizar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 55.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleSmall
                        .override(
                          fontFamily: 'Lato',
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

