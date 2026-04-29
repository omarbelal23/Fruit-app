import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildMenuSection(),
            const SizedBox(height: 24),
            _buildSignOutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Header
  // ─────────────────────────────────────────────
  Widget _buildProfileHeader() {
    final user = _user;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      decoration: const BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // ✅ Avatar — قابل للضغط لتغيير الصورة مستقبلاً
          GestureDetector(
            onTap: _showComingSoon,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: ClipOval(
                child: user?.photoURL != null
                    ? Image.network(
                        user!.photoURL!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatar(),
                      )
                    : _defaultAvatar(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'User',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'No email',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 14),
          _VerifiedBadge(isVerified: user?.emailVerified ?? false),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Icon(
      Icons.person_rounded,
      size: 44,
      color: Colors.white.withValues(alpha: 0.85),
    );
  }

  // ─────────────────────────────────────────────
  //  Menu
  // ─────────────────────────────────────────────
  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          subtitle: 'View your order history',
          onTap: () => Get.toNamed('/orders'),
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Delivery Addresses',
          subtitle: 'Manage your delivery locations',
          onTap: _showAddressesSheet,
        ),
        _buildMenuItem(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: _showPaymentSheet,
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: _showNotificationsSheet,
        ),
        _buildMenuItem(
          icon: Icons.lock_outline_rounded,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: _showChangePasswordSheet,
        ),
        _buildMenuItem(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: _showHelpSheet,
        ),
        _buildMenuItem(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'App version and information',
          onTap: _showAboutDialog,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kMainColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kMainColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: kTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: kTextLightColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: kTextLightColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
    );
  }

  // ─────────────────────────────────────────────
  //  Sign Out
  // ─────────────────────────────────────────────
  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _showSignOutDialog,
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text(
            'Sign Out',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: kErrorColor,
            side: const BorderSide(color: kErrorColor),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Bottom Sheets — بدل صفحات تانية
  // ─────────────────────────────────────────────

  void _showAddressesSheet() {
    _showSheet(
      title: 'Delivery Addresses',
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          _SheetEmptyState(
            icon: Icons.location_off_outlined,
            message: 'No saved addresses yet.\nAdd an address to get started.',
          ),
          const SizedBox(height: 16),
          _SheetActionButton(
            label: 'Add New Address',
            icon: Icons.add_location_alt_outlined,
            onTap: _showComingSoon,
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet() {
    _showSheet(
      title: 'Payment Methods',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          _PaymentMethodTile(
            icon: Icons.money,
            label: 'Cash on Delivery',
            isSelected: true,
            onTap: () {},
          ),
          _PaymentMethodTile(
            icon: Icons.credit_card,
            label: 'Credit / Debit Card',
            isSelected: false,
            onTap: _showComingSoon,
          ),
          _PaymentMethodTile(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Digital Wallet',
            isSelected: false,
            onTap: _showComingSoon,
          ),
        ],
      ),
    );
  }

  void _showNotificationsSheet() {
    _showSheet(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      child: _NotificationSettings(),
    );
  }

  void _showChangePasswordSheet() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    _showSheet(
      title: 'Change Password',
      icon: Icons.lock_outline_rounded,
      child: Column(
        children: [
          _SheetTextField(
            controller: currentCtrl,
            label: 'Current Password',
            isPassword: true,
          ),
          const SizedBox(height: 12),
          _SheetTextField(
            controller: newCtrl,
            label: 'New Password',
            isPassword: true,
          ),
          const SizedBox(height: 12),
          _SheetTextField(
            controller: confirmCtrl,
            label: 'Confirm New Password',
            isPassword: true,
          ),
          const SizedBox(height: 20),
          _SheetActionButton(
            label: 'Update Password',
            icon: Icons.check_rounded,
            onTap: () {
              if (newCtrl.text != confirmCtrl.text) {
                Get.snackbar(
                  'Error',
                  'Passwords do not match',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: kErrorColor,
                  colorText: Colors.white,
                );
                return;
              }
              if (newCtrl.text.length < 6) {
                Get.snackbar(
                  'Error',
                  'Password must be at least 6 characters',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: kErrorColor,
                  colorText: Colors.white,
                );
                return;
              }
              _handleChangePassword(newCtrl.text);
            },
          ),
        ],
      ),
    );
  }

  void _showHelpSheet() {
    _showSheet(
      title: 'Help & Support',
      icon: Icons.help_outline_rounded,
      child: Column(
        children: [
          _HelpTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: _showComingSoon,
          ),
          _HelpTile(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'support@fruitmarket.com',
            onTap: _showComingSoon,
          ),
          _HelpTile(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+20 100 000 0000',
            onTap: _showComingSoon,
          ),
          _HelpTile(
            icon: Icons.quiz_outlined,
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
            onTap: _showComingSoon,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Dialogs
  // ─────────────────────────────────────────────

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: kTextLightColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _handleSignOut();
            },
            style: TextButton.styleFrom(foregroundColor: kErrorColor),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.eco_rounded, color: kMainColor),
            const SizedBox(width: 8),
            const Text('Fruit Market'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'A modern fruit e-commerce app built with Flutter and Firebase.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '© 2025 Fruit Market. All rights reserved.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Actions
  // ─────────────────────────────────────────────

  Future<void> _handleSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Get.offAllNamed('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to sign out. Please try again.'),
          backgroundColor: kErrorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _handleChangePassword(String newPassword) async {
    try {
      await _user?.updatePassword(newPassword);
      if (!mounted) return;
      Navigator.of(context).pop(); // أغلق الـ sheet
      Get.snackbar(
        'Success ✅',
        'Password updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kSuccessColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update password. Please re-login and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kErrorColor,
        colorText: Colors.white,
      );
    }
  }

  void _showComingSoon() {
    Get.snackbar(
      'Coming Soon 🚀',
      'This feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ─────────────────────────────────────────────
  //  Helper — sheet builder
  // ─────────────────────────────────────────────

  void _showSheet({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kBorderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Icon(icon, color: kMainColor, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Reusable Sheet Widgets
// ─────────────────────────────────────────────────────────────────

class _SheetEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _SheetEmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 56, color: kTextLightColor),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: kTextLightColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SheetActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

class _SheetTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const _SheetTextField({
    required this.controller,
    required this.label,
    this.isPassword = false,
  });

  @override
  State<_SheetTextField> createState() => _SheetTextFieldState();
}

class _SheetTextFieldState extends State<_SheetTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kMainColor, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: kTextLightColor,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? kMainColor : kBorderColor,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? kMainColor.withValues(alpha: 0.05) : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? kMainColor : kTextLightColor),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? kMainColor : kTextColor,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: kMainColor)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _NotificationSettings extends StatefulWidget {
  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings> {
  bool _orders = true;
  bool _promotions = false;
  bool _delivery = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NotifTile(
          title: 'Order Updates',
          subtitle: 'Get notified about your order status',
          value: _orders,
          onChanged: (v) => setState(() => _orders = v),
        ),
        _NotifTile(
          title: 'Promotions & Offers',
          subtitle: 'Receive deals and discounts',
          value: _promotions,
          onChanged: (v) => setState(() => _promotions = v),
        ),
        _NotifTile(
          title: 'Delivery Alerts',
          subtitle: 'Know when your order is nearby',
          value: _delivery,
          onChanged: (v) => setState(() => _delivery = v),
        ),
      ],
    );
  }
}

class _NotifTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: kTextLightColor),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: kMainColor,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kMainColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kMainColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: kTextLightColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: kTextLightColor,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Verified Badge
// ─────────────────────────────────────────────────────────────────

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.isVerified});

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_rounded : Icons.cancel_outlined,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            isVerified ? 'Verified Account' : 'Unverified Account',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
