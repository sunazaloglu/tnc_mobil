import 'package:flutter/material.dart';
import 'package:tnc_mobil/components/product_card.dart';
import 'package:tnc_mobil/model/product_model.dart';
import 'package:tnc_mobil/services/api_service.dart';
import 'package:tnc_mobil/views/cart_screen.dart';
import 'package:tnc_mobil/views/product_detail_screen.dart';

// Ürün listesinin ve arama alanının gösterildiği ana ekran.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Arama kutusundaki metni kontrol etmek için.
  TextEditingController searchController = TextEditingController();
  // API çağrısı sırasında yüklenme durumunu tutar.
  bool isLoading = false;
  // Ürünleri çekerken oluşan hata mesajı.
  String errorMessage = "";
  // API'den gelen tüm ürünler.
  List<ProductModel> allProducts = [];
  // Ürün verilerini sağlayan servis sınıfı.
  ApiService apiService = ApiService();
  // Sepete eklenmiş ürün id'lerini tutar.
  final Set<int> cartIds = {};
  // Arama çubuğuna yazılan son sorgu.
  String searchQuery = "";

  @override
  void initState() {
    // Ekran açılır açılmaz ürünleri yükle.
    loadProducts();

    super.initState();
  }

  // REST API'den ürünleri çeker ve durumları günceller.
  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      final products = await apiService.fetchProducts();
      print('GELEN PRODUCT SAYISI: ${products.length}');
      setState(() {
        allProducts = products;
        errorMessage = "";
      });
    } catch (e) {
      print('API HATASI: $e');
      setState(() {
        errorMessage = "Failed to load products";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Arama metnine göre filtrelenmiş ürün listesi.
    final filteredProducts = allProducts.where((product) {
      final name = product.title ?? "";
      return name.toUpperCase().contains(searchQuery.toUpperCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            products: allProducts,
                            cartIds: cartIds,
                          ),
                        ),
                      );
                    },
                    iconSize: 32,
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                ],
              ),
              SizedBox(height: 8),

              Text(
                "Find your perfect gift.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              SizedBox(height: 14),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search products",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 16),

              Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://wantapi.com/assets/banner.png",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage != "")
                Center(child: Text(errorMessage))
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.8, // daha küçük kartlar için oranı artırdık
                        ), //SliverGridDelegateWithFixedCrossAxisCount
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: product,
                                cartIds: cartIds,
                              ),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    }, //itemBuilder
                  ), //GridView.builder
                ), //Expanded
            ],
          ), //Column
        ), //Padding
      ), //SafeArea
    ); //Scaffold
  } //build
} //_HomeScreenState
