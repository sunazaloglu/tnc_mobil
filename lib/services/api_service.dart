import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tnc_mobil/model/product_model.dart';

// Ürün verilerini uzaktaki fakestore API'sinden çeken servis sınıfı.
class ApiService {
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        return [ProductModel.fromJson(data as Map<String, dynamic>)];
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
