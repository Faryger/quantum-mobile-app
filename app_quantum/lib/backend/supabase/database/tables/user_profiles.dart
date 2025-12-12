import '../database.dart';

class UserProfilesTable extends SupabaseTable<UserProfilesRow> {
  @override
  String get tableName => 'UserProfiles';

  @override
  UserProfilesRow createRow(Map<String, dynamic> data) => UserProfilesRow(data);
}

class UserProfilesRow extends SupabaseDataRow {
  UserProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserProfilesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get firstName => getField<String>('FirstName');
  set firstName(String? value) => setField<String>('FirstName', value);

  String? get lastName => getField<String>('LastName');
  set lastName(String? value) => setField<String>('LastName', value);

  DateTime? get dateOfBirth => getField<DateTime>('DateOfBirth');
  set dateOfBirth(DateTime? value) => setField<DateTime>('DateOfBirth', value);
}
