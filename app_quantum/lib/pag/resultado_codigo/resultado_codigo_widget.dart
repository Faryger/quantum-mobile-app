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
  String _registrationType = 'Asistencia';
  String _registrationTime = '';
  String _registrationDate = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResultadoCodigoModel());
    _processScannedCode();
    final now = DateTime.now();
    _registrationTime = DateFormat('h:mm a').format(now);
    _registrationDate = DateFormat('EEEE, d \'de\' MMMM', 'es_ES').format(now);
  }

  void _processScannedCode() {
    final code = widget.scannedCode ?? '';
    if (code.toLowerCase().contains('entrada')) {
      _registrationType = 'Entrada';
    } else if (code.toLowerCase().contains('salida')) {
      _registrationType = 'Salida';
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
              // Spacer to push content to center
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
                          color: Color(0xFF4CAF50),
                          width: 3.0,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Color(0xFF4CAF50),
                        size: 80.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        '${_registrationType} Registrada',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .displaySmall
                            .override(
                              font: GoogleFonts.lato(),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        '$_registrationDate a las $_registrationTime',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.lato(),
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
                    context.goNamed(CameraScanWidget.routeName);
                  },
                  text: 'Finalizar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 55.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleSmall
                        .override(
                          font: GoogleFonts.lato(),
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

