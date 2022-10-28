import 'package:flutter/material.dart';

import '../constants/cabinets.dart';

Widget carouselCard(int index, num distance, num duration) {
  return Container(
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cabinets[index]['image']),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cabinets[index]['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(cabinets[index]['adresse'],
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text(
                      '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    ),
    decoration: new BoxDecoration(
      boxShadow: [
        new BoxShadow(
          color: Colors.black26,
          blurRadius: 15.5,
        ),
      ],
    ),
  );
}