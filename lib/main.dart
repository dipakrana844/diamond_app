import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practical_app/utils/excel_helper.dart' show ExcelHelper;

import 'bloc/diamond_bloc.dart';
import 'data.dart';
import 'models/diamond_model.dart';
import 'pages/filter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<Diamond> diamonds = await loadDiamonds();

  final uniqueValues = await ExcelHelper.getUniqueValues();

  runApp(MyApp(diamonds: diamonds, uniqueValues: uniqueValues));
}

class MyApp extends StatelessWidget {
  final List<Diamond> diamonds;
  final Map<String, List<String>> uniqueValues;

  const MyApp({Key? key, required this.diamonds, required this.uniqueValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiamondBloc()..add(LoadDiamonds(diamonds)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FilterPage(
          labs: uniqueValues['labs']!,
          shapes: uniqueValues['shapes']!,
          colors: uniqueValues['colors']!,
          clarities: uniqueValues['clarities']!,
        ),
      ),
    );
  }
}
