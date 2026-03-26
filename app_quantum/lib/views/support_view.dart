import 'package:flutter/material.dart';
import '../backend/api_client.dart';
import '../components/nav_bar_widget.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home/home_page/home_page_model.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});
  static String routeName = 'supportView';
  static String routePath = '/supportView';

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  late Future<List<dynamic>> _futureData;
  late HomePageModel _navModel;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getSupport();
    _navModel = createModel(context, () => HomePageModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Soporte', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Sin tickets de soporte', style: TextStyle(fontFamily: 'Readex Pro')));

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF14B8A6).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.support_agent_rounded, color: Color(0xFF14B8A6), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ticket #${item['id']}", style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                          Text("Detalle: ${item['support_detail'] ?? 'N/A'}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
      bottomNavigationBar: wrapWithModel(
        model: _navModel.navBarModel,
        updateCallback: () => setState(() {}),
        child: const NavBarWidget(),
      ),
    );
  }
}
