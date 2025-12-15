import '../database.dart';

class AsistenciaTable extends SupabaseTable<AsistenciaRow> {
  @override
  String get tableName => 'asistencia';

  @override
  AsistenciaRow createRow(Map<String, dynamic> data) => AsistenciaRow(data);
}

class AsistenciaRow extends SupabaseDataRow {
  AsistenciaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AsistenciaTable();

  int get id => getField<int>('id')!;
  DateTime get createdAt => getField<DateTime>('created_at')!;
  String? get scannedId => getField<String>('scanned_id');
  DateTime? get entryTime => getField<DateTime>('entry_time');
  DateTime? get exitTime => getField<DateTime>('exit_time');
  set exitTime(DateTime? value) => setField<DateTime>('exit_time', value);
  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
