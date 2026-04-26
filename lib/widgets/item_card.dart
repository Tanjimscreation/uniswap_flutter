import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  const ItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.r20),
        boxShadow: AppTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ──
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Network image with shimmer placeholder
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.r20),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: AppTheme.shimmerGradient,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                            color: AppTheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.shimmerGradient,
                      ),
                      child: const Icon(Icons.image_outlined,
                          color: AppTheme.textHint, size: 32),
                    ),
                  ),
                ),

                // Condition badge — top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.condition.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: product.condition.color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      product.condition.label,
                      style: TextStyle(
                        color: product.condition.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // Swap overlay — top left
                if (product.swapOnly)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz_rounded,
                              color: Colors.white, size: 11),
                          SizedBox(width: 3),
                          Text(
                            'SWAP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Subtle vignette at bottom for readability
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info Section ──
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.headingSm.copyWith(fontSize: 13),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          product.swapOnly
                              ? 'Swap Only'
                              : 'RM ${product.priceRm.toStringAsFixed(0)}',
                          style: product.swapOnly
                              ? AppTheme.labelSm.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                )
                              : AppTheme.priceLg.copyWith(fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.bgLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.category,
                          style: AppTheme.bodySm.copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
