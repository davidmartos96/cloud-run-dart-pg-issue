import 'dart:io';

import 'package:functions_framework/functions_framework.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  final dbConnection = getDbConnection();

  await dbConnection.open();
  print("DB connection opened");
  final rows = await dbConnection.query("SELECT 1");
  await dbConnection.close();
  print("DB connection closed");

  final res = rows.first.first as int;
  final now = DateTime.now();
  return Response.ok('Response from database: $res\n\nDate: $now');
}

PostgreSQLConnection getDbConnection() {
  // When running locally we provider a custom socket path from the postgres container
  String? socketPath = Platform.environment["DB_SOCKET_PATH"];
  if (socketPath == null) {
    // Build Cloud SQL socket path
    final dbSocketPath = '/cloudsql';
    final connectionName = Platform.environment["CLOUD_SQL_CONNECTION_NAME"]!;
    socketPath = "$dbSocketPath/$connectionName/.s.PGSQL.5432";
  }

  final port = 5432;
  final String databaseName = Platform.environment["DB_NAME"]!;
  final String user = Platform.environment["DB_USER"]!;
  final String password = Platform.environment["DB_PASS"]!;

  print('''
Creating connection with:
  socketPath: $socketPath
  databaseName: $databaseName
  user: $user
  password: $password
''');

  return PostgreSQLConnection(
    socketPath,
    port,
    databaseName,
    isUnixSocket: true,
    username: user,
    password: password,
  );
}
