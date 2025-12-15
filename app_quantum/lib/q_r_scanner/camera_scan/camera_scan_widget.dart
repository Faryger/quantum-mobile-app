import 'dart:async';
import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'camera_scan_model.dart';
export 'camera_scan_model.dart';

class CameraScanWidget extends StatefulWidget {
  const CameraScanWidget({super.key});

  static String routeName = 'Camera_Scan';
  static String routePath = '/cameraScan';

  @override
  State<CameraScanWidget> createState() => _CameraScanWidgetState();
}

class _CameraScanWidgetState extends State<CameraScanWidget> {
  late CameraScanModel _model;
  late String _timeString;
  Timer? _timer;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CameraScanModel());
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  void dispose() {
    _model.dispose();
    _timer?.cancel();
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Registrar Asistencia',
                      style: FlutterFlowTheme.of(context).headlineLarge.override(
                            font: GoogleFonts.lato(),
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        _timeString,
                        style: FlutterFlowTheme.of(context).displayLarge.override(
                              font: GoogleFonts.lato(),
                              color: Colors.white,
                              fontSize: 80.0,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Coloca el código QR del empleado frente a la cámara para registrar su entrada o salida.',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.lato(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16.0,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _model.resultado =
                              await FlutterBarcodeScanner.scanBarcode(
                            '#4CAF50', // scanning line color
                            'Cancelar', // cancel button text
                            true, // whether to show the flash icon
                            ScanMode.QR,
                          );

                          if (_model.resultado != null &&
                              _model.resultado != '-1') {
                            context.pushNamed(
                              ResultadoCodigoWidget.routeName,
                              pathParameters: {
                                'scannedCode': _model.resultado!,
                              }.withoutNulls,
                            );
                          }
                          safeSetState(() {});
                        },
                        text: 'Escanear QR',
                        icon: Icon(
                          Icons.qr_code_scanner,
                          size: 24.0,
                        ),
                        options: FFButtonOptions(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60.0,
                          padding: EdgeInsets.all(0),
                          iconPadding: EdgeInsets.only(right: 12.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.lato(),
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                          elevation: 3.0,
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
            wrapWithModel(
              model: _model.navBarModel,
              updateCallback: () => safeSetState(() {}),
              child: NavBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
