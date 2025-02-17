import '../models/diamond_model.dart';
import '../utils/excel_helper.dart';

Future<List<Diamond>> loadDiamonds() async {
  return await ExcelHelper.readExcelData();
}
