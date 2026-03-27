import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../backend/api_client.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

import '/views/contract_view.dart';
import '/views/journey_view.dart';
import '/views/permission_view.dart';
import '/views/schedule_view.dart';
import '/views/shift_view.dart';
import '/views/support_view.dart';
import '/asistencia/asistencia_widget.dart';
import '/permisos/permises_list/permises_list_widget.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'homePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = 'Usuario';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await ApiClient.getUsername();
    if (mounted) setState(() => _username = name);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  static List<_NavItem> get _items => [
        _NavItem(Icons.fact_check_rounded,       'Asistencias',  AsistenciaWidget.routePath,   const Color(0xFF14B8A6)),
        _NavItem(Icons.edit_calendar_rounded,    'Permisos',     PermisesListWidget.routePath, const Color(0xFF14B8A6)),
        _NavItem(Icons.description_rounded,      'Contratos',    ContractView.routePath,        const Color(0xFF14B8A6)),
        _NavItem(Icons.map_rounded,               'Jornadas',     JourneyView.routePath,         const Color(0xFF14B8A6)),
        _NavItem(Icons.calendar_month_rounded,    'Horarios',     ScheduleView.routePath,        const Color(0xFF14B8A6)),
        _NavItem(Icons.timer_rounded,             'Turnos',       ShiftView.routePath,           const Color(0xFF14B8A6)),
        _NavItem(Icons.person_search_rounded,     'Detalle P.',   PermissionView.routePath,      const Color(0xFF14B8A6)),
        _NavItem(Icons.contact_support_rounded,   'Soporte',      SupportView.routePath,         const Color(0xFF14B8A6)),
      ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(username: _username),
                  const SizedBox(height: 12),
                  _HeroCard(username: _username, dateStr: dateStr),
                  const SizedBox(height: 32),
                  const _SectionTitle(title: 'Módulos de Gestión'),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.2,
                    ),
                    itemBuilder: (ctx, i) => _ModuleCard(item: _items[i]),
                  ),
                  const SizedBox(height: 32),
                  const _SectionTitle(title: 'Actividad Reciente'),
                  const SizedBox(height: 16),
                  _ActivityItem(
                    title: 'Inicio de sesión exitoso',
                    time: 'Hace pocos minutos',
                    icon: Icons.login_rounded,
                  ),
                  _ActivityItem(
                    title: 'Conexión al servidor establecida',
                    time: 'Estado: Operativo',
                    icon: Icons.bolt_rounded,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: wrapWithModel(
          model: _model.navBarModel,
          updateCallback: () => setState(() {}),
          child: const NavBarWidget(currentPage: 'home'),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String   label;
  final String   routePath;
  final Color    color;
  const _NavItem(this.icon, this.label, this.routePath, this.color);
}

class _TopBar extends StatelessWidget {
  final String username;
  const _TopBar({required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(fontFamily: 'Outfit', fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE2E8F0),
          backgroundImage: const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String username;
  final String dateStr;
  const _HeroCard({required this.username, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF0D9488).withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('¡Bienvenido de nuevo!', style: TextStyle(fontFamily: 'Readex Pro', fontSize: 13, color: Colors.white70)),
          Text(username, style: const TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),
          Text(dateStr, style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 13, color: Colors.white60)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF334155)));
  }
}

class _ModuleCard extends StatelessWidget {
  final _NavItem item;
  const _ModuleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go(item.routePath),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: item.color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item.label, style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  const _ActivityItem({required this.title, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle), child: Icon(icon, size: 16, color: const Color(0xFF64748B))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
              Text(time, style: const TextStyle(fontFamily: 'Readex Pro', fontSize: 11, color: Color(0xFF94A3B8))),
            ]),
          ),
        ],
      ),
    );
  }
}