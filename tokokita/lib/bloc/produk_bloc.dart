import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    try {
      String apiUrl = ApiUrl.listProduk;
      var response = await Api().get(apiUrl);

      print('🔵 Get Produks Status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load products, status: ${response.statusCode}',
        );
      }

      var jsonObj = json.decode(response.body);
      if (jsonObj == null || jsonObj is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      List<dynamic> listProduk = jsonObj['data'] ?? [];
      List<Produk> produks = [];

      for (var item in listProduk) {
        if (item is Map<String, dynamic>) {
          produks.add(Produk.fromJson(item));
        } else if (item is Map) {
          produks.add(Produk.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      return produks;
    } catch (e) {
      print('🔴 Error getProduks: $e');
      rethrow;
    }
  }

  static Future<bool> addProduk({required Produk produk}) async {
    try {
      String apiUrl = ApiUrl.createProduk;

      // Kirim body sebagai Map<String, dynamic> dengan types yang tepat
      var body = produk.toJson();

      print('🔵 [addProduk] URL: $apiUrl');
      print('🔵 [addProduk] Body: $body');

      var response = await Api().post(apiUrl, body);

      print('🟢 [addProduk] Status: ${response.statusCode}');
      print('🟢 [addProduk] Response: ${response.body}');

      Map<String, dynamic>? jsonObj;
      try {
        jsonObj = json.decode(response.body) as Map<String, dynamic>?;
      } catch (_) {
        jsonObj = null;
      }

      // Periksa JSON body untuk memastikan server menandai success
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonObj != null &&
            (jsonObj['status'] == false ||
                (jsonObj['code'] != null && jsonObj['code'] >= 400))) {
          final msg = jsonObj['message'] ?? response.body;
          throw Exception('Server error: $msg');
        }
        return true;
      } else {
        final msg = jsonObj != null
            ? (jsonObj['message'] ?? response.body)
            : response.body;
        throw Exception(
          'Add produk failed with status ${response.statusCode}: $msg',
        );
      }
    } catch (e) {
      print('🔴 [addProduk] Error: $e');
      rethrow;
    }
  }

  static Future<bool> updateProduk({required Produk produk}) async {
    try {
      String apiUrl = ApiUrl.updateProduk(produk.id!);
      var body = produk.toJson();
      print('🔵 [updateProduk] URL: $apiUrl Body: $body');

      var response = await Api().put(apiUrl, body);

      print('🟢 [updateProduk] Status: ${response.statusCode}');
      print('🟢 [updateProduk] Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonObj = json.decode(response.body) as Map<String, dynamic>?;
        if (jsonObj != null &&
            (jsonObj['status'] == false ||
                (jsonObj['code'] != null && jsonObj['code'] >= 400))) {
          throw Exception(
            'Server error: ${jsonObj['message'] ?? response.body}',
          );
        }
        return true;
      } else {
        throw Exception('Update produk failed, status: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 [updateProduk] Error: $e');
      rethrow;
    }
  }

  static Future<bool> deleteProduk({required int id}) async {
    try {
      String apiUrl = ApiUrl.deleteProduk(id);
      var response = await Api().delete(apiUrl);

      print('🟢 [deleteProduk] Status: ${response.statusCode}');
      print('🟢 [deleteProduk] Response: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Delete produk failed, status: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 [deleteProduk] Error: $e');
      rethrow;
    }
  }
}
