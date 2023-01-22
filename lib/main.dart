import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';

// import 'package:mb_ope/db/database.dart';

import 'package:solo_verde/app.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  /*runApp(Provider<Database>(
    create: (context) => Database(),
    child: const App(),
    dispose: (context, Database db) => db.close(),
  ));*/
  runApp(const App());
}
