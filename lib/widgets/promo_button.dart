import 'package:flutter/material.dart';

Widget PromoButton() {
  return Container(
    margin: EdgeInsets.only(top: 15),
    width: double.infinity,
    height: 50,
    child: OutlinedButton(
      onPressed: () {
        // TODO: Handle promo code
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[400]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'Apply Promo Code',
        style: TextStyle(color: Colors.grey[700], fontSize: 16),
      ),
    ),
  );
}
