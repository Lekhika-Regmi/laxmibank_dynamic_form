import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/merchant_groups.dart';

final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3003'));

Future<List<MerchantGroup>> fetchMerchantGroups() async {
  try {
    final response = await dio.get('/merchants');

    if (response.statusCode == 200) {
      // ✅ Get the data Map
      final data = response.data['data'];

      // ✅ Get merchantGroups list from data
      final List<dynamic> merchantGroupsJson = data['merchantGroups'];

      // ✅ Parse each merchant group
      final merchantGroups = merchantGroupsJson
          .map((json) => MerchantGroup.fromJson(json as Map<String, dynamic>))
          .toList();

      return merchantGroups;
    } else {
      throw Exception('Failed to load merchants: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Network error: ${e.message}');
  } catch (e) {
    throw Exception('Fetch merchant groups failed: $e');
  }
}
