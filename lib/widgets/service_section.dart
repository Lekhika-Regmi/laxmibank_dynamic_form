import 'package:flutter/material.dart';
import '../models/merchant_groups.dart';
import '../models/merchant.dart';

class ServiceSection extends StatelessWidget {
  final MerchantGroup merchantGroup;
  final Function(Merchant)? onMerchantTap;
  final VoidCallback? onViewAll;

  const ServiceSection({
    super.key,
    required this.merchantGroup,
    this.onMerchantTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final visibleMerchants = merchantGroup.visibleMerchants;
    final displayMerchants = visibleMerchants.length > 4
        ? visibleMerchants.sublist(0, 4)
        : visibleMerchants;

    return Container(
      margin: const EdgeInsets.only(top: 15, right: 12, left: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: LinearGradient(
        //   colors: [
        //     Colors.white,
        //     Color.fromARGB(255, 255, 229, 206),
        //   ], // Customize colors
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + optional View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                merchantGroup.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (visibleMerchants.length > 4 && onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All >',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Merchant Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            children: displayMerchants
                .map(
                  (merchant) => GestureDetector(
                    onTap: () => onMerchantTap?.call(merchant),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffEF7D17).withAlpha(150),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: merchant.icon.isNotEmpty
                                ? Image.network(
                                    merchant.icon,
                                    width: 30,
                                    height: 35,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error, size: 30);
                                    },
                                  )
                                : Icon(Icons.mobile_friendly, size: 30,color: Colors.grey[700],),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              merchant.name,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
