import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  });

  factory ProductCard.fromModel(ProductModel model) => ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price,
      );

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: bodyTextColor,
                  ),
                ),
                Text('￦$price',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
