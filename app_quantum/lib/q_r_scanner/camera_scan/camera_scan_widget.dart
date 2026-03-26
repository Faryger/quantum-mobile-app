import 'dart:async';
import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../index.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B8A6).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF14B8A6), size: 40),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Registrar Asistencia',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _timeString,
                      style: GoogleFonts.outfit(
                        fontSize: 72,
                        fontWeight: FontWeight.w200,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Text(
                        'Acercate al QR para escanear la entrada o la salida.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    FFButtonWidget(
                      onPressed: () async {
                        _model.resultado = await FlutterBarcodeScanner.scanBarcode(
                          '#14B8A6',
                          'Cancelar',
                          true,
                          ScanMode.QR,
                        );

                        if (_model.resultado != null && _model.resultado != '-1') {
                          if (context.mounted) {
                            context.pushNamed(
                              ResultadoCodigoWidget.routeName,
                              pathParameters: {
                                'scannedCode': _model.resultado!,
                              }.withoutNulls,
                            );
                          }
                        }
                        setState(() {});
                      },
                      text: 'Escanear Código QR',
                      icon: const Icon(Icons.center_focus_weak_rounded, size: 24),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 64,
                        color: const Color(0xFF14B8A6),
                        textStyle: const TextStyle(fontFamily: 'Outfit', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        elevation: 4,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            wrapWithModel(
              model: _model.navBarModel,
              updateCallback: () => setState(() {}),
              child: const NavBarWidget(currentPage: 'scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
