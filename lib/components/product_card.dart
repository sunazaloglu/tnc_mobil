import 'package:flutter/material.dart';
import 'package:tnc_mobil/model/product_model.dart';

// Ana ekranda ürünleri kutu şeklinde gösteren kart bileşeni.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 3),
          ), //BoxShadow
        ],
      ), //BoxDecoration
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: product.id ?? 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: product.image != null && product.image!.isNotEmpty
                      ? Image.network(product.image!, fit: BoxFit.contain)
                      : const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 1),

                Text(
                  product.description ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  product.price != null ? '${product.price}' : 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ), //Column
    ); //Container
  }
}
