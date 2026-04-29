import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const _features = <_FeatureItem>[
    _FeatureItem(
      icon: Icons.favorite_rounded,
      title: 'Save Products',
      description: 'Tap the heart icon on any product to add it to favorites',
    ),
    _FeatureItem(
      icon: Icons.notifications_rounded,
      title: 'Get Notified',
      description: 'Receive updates when your favorite products are on sale',
    ),
    _FeatureItem(
      icon: Icons.share_rounded,
      title: 'Share with Friends',
      description: 'Share your favorite finds with friends and family',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // ✅ SingleChildScrollView لو الشاشة صغيرة ما يحصلش overflow
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            _buildEmptyState(),
            const SizedBox(height: 32),
            _buildFeaturesCard(),
            const SizedBox(height: 32),
            _buildShopButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: kSecondaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_outline_rounded,
            size: 64,
            color: kSecondaryColor,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'No favorites yet',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Save your favorite products for quick access\nand personalized recommendations.',
          style: TextStyle(fontSize: 15, color: kTextLightColor, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        border: Border.all(color: kBorderColor),
      ),
      // ✅ data-driven بدل تكرار _buildFeatureItem يدوياً مع SizedBox بينهم
      child: Column(
        children: _features
            .map<Widget>((f) => _FeatureTile(item: f))
            .toList()
            // ✅ Divider بين العناصر بدل SizedBox يدوي
            .separator(const Divider(height: 24, thickness: 0.5)),
      ),
    );
  }

  Widget _buildShopButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Get.offAllNamed('/home'),
        // ✅ offAllNamed عشان مش نبني stack فوق home
        icon: const Icon(Icons.storefront_rounded, size: 18),
        label: const Text(
          'Start Shopping',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// Helper model & widget
// ────────────────────────────────────────────────

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});

  final _FeatureItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kMainColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: kMainColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 12,
                  color: kTextLightColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ✅ Extension بسيط لإضافة separator بين عناصر List
extension _ListSeparator on List<Widget> {
  List<Widget> separator(Widget sep) {
    if (length <= 1) return this;
    return [
      for (int i = 0; i < length; i++) ...[this[i], if (i < length - 1) sep],
    ];
  }
}
