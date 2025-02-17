import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../models/diamond_model.dart';

class ExcelHelper {
  static Future<List<Diamond>> readExcelData() async {
    final List<Diamond> diamonds = [];

    try {
      final ByteData data = await rootBundle.load(
        'assets/Flutter-test-dataset.xlsx',
      );
      final List<int> bytes = data.buffer.asUint8List();

      final Excel excel = Excel.decodeBytes(bytes);

      final Sheet sheet = excel.tables[excel.tables.keys.first]!;
      // debugPrint("Sheet name: ${sheet.name}");

      final headerRow = sheet.rows[0];
      debugPrint(
        "Header Row: ${headerRow.map((cell) => cell?.value.toString()).toList()}",
      );

      for (var row in sheet.rows.skip(2)) {
        // Debug: Print the entire row
        // debugPrint(
        //   "Row: ${row.map((cell) => cell?.value.toString()).toList()}",
        // );

        final lotId = row[4]?.value.toString()?.trim() ?? '';

        if (lotId.isNotEmpty && int.tryParse(lotId) != null) {
          final finalAmount = double.parse(row[6]!.value.toString()) *
              double.parse(row[16]!.value.toString());
          final diamond = Diamond(
            lotId: lotId,
            size: row[5]?.value.toString() ?? '',
            carat: double.tryParse(row[6]?.value.toString() ?? '0') ?? 0,
            lab: row[7]?.value.toString() ?? '',
            shape: row[8]?.value.toString() ?? '',
            color: row[9]?.value.toString() ?? '',
            clarity: row[10]?.value.toString() ?? '',
            cut: row[11]?.value.toString() ?? '',
            polish: row[12]?.value.toString() ?? '',
            symmetry: row[13]?.value.toString() ?? '',
            fluorescence: row[14]?.value.toString() ?? '',
            discount: double.tryParse(row[15]?.value.toString() ?? '0') ?? 0,
            perCaratRate: double.tryParse(
                  row[16]?.value.toString()?.replaceAll(',', '') ?? '0',
                ) ??
                0,
            finalAmount: finalAmount,
            keyToSymbol: row[18]?.value.toString() ?? '',
            labComment: row[19]?.value.toString() ?? '',
          );

          diamonds.add(diamond);
        }
      }
    } catch (e) {
      debugPrint('Error reading Excel file: $e');
    }

    return diamonds;
  }

  static Future<Map<String, List<String>>> getUniqueValues() async {
    final List<Diamond> diamonds = await readExcelData();

    final Set<String> labs = diamonds.map((d) => d.lab).toSet();
    final Set<String> shapes = diamonds.map((d) => d.shape).toSet();
    final Set<String> colors = diamonds.map((d) => d.color).toSet();
    final Set<String> clarities = diamonds.map((d) => d.clarity).toSet();

    return {
      'labs': labs.toList(),
      'shapes': shapes.toList(),
      'colors': colors.toList(),
      'clarities': clarities.toList(),
    };
  }
}
