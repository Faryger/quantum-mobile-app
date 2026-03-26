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
  String _messageTitle = 'Simulando...';
  String _messageSubtitle = 'Esta funcionalidad ha sido migrada temporalmente a interfaz de solo vista en este MVP.';
  IconData _messageIcon = Icons.hourglass_empty;
  Color _messageIconColor = Colors.grey;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResultadoCodigoModel());
    _simulateScan();
  }

  Future<void> _simulateScan() async {
    // Stub functionality to bypass Supabase
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _messageTitle = 'Función en Migración';
      _messageSubtitle = 'Para hacer el pase de entrada/salida necesitas endpoints POST en el backend.';
      _messageIcon = Icons.info_outline;
      _messageIconColor = Colors.blue;
    });
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
