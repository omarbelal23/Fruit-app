import 'package:flutter/material.dart';

// Colors
const Color kMainColor = Color(0xFF69A03A);
const Color kSecondaryColor = Color(0xFF4CAF50);
const Color kAccentColor = Color(0xFFFF9800);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kCardColor = Colors.white;
const Color kTextColor = Color(0xFF333333);
const Color kTextLightColor = Color(0xFF666666);
const Color kBorderColor = Color(0xFFE0E0E0);
const Color kErrorColor = Color(0xFFE53935);
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kWarningColor = Color(0xFFFF9800);

// Gradients
const LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kMainColor, kSecondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Spacing
const double kDefaultPadding = 16.0;
const double kDefaultBorderRadius = 12.0;
const double kDefaultElevation = 4.0;

// Text Styles
const double kHeadline1Size = 24.0;
const double kHeadline2Size = 20.0;
const double kBodyTextSize = 16.0;
const double kCaptionTextSize = 12.0;

// Font Weights
const FontWeight kBold = FontWeight.bold;
const FontWeight kSemiBold = FontWeight.w600;
const FontWeight kMedium = FontWeight.w500;
const FontWeight kRegular = FontWeight.normal;

// Assets
const String kLogo = 'assets/images/logo.png';
const String kSplashImage = 'assets/images/splash_view_image.png';

// API Keys (if needed)
const String kGoogleMapsApiKey = 'YOUR_API_KEY_HERE';

// Collection Names
const String kUsersCollection = 'users';
const String kProductsCollection = 'products';
const String kCartCollection = 'cart';
const String kOrdersCollection = 'orders';

// Field Names
const String kIsProfileComplete = 'isProfileComplete';
const String kUserName = 'name';
const String kUserPhone = 'phone';
const String kUserAddress = 'address';

// Product Categories
const List<String> kProductCategories = [
  'All',
  'Fruits',
  'Vegetables',
  'Organic',
  'Seasonal',
];

// App Strings
const String kAppName = 'Fruit Market';
const String kWelcomeMessage = 'Good morning! 👋';
const String kSearchHint = 'What fruit are you looking for?';
const String kFeaturedProducts = 'Featured Products';
const String kFreshFruits = 'Fresh Fruits';
const String kYourCart = 'Your Cart';
const String kProceedToCheckout = 'Proceed to Checkout';
const String kAddToCart = 'Add to Cart';
const String kRemoveFromCart = 'Remove from Cart';
const String kQuantity = 'Quantity';
const String kTotal = 'Total';
const String kSubtotal = 'Subtotal';
const String kShipping = 'Shipping';
const String kSalesTax = 'Sales Tax';

// Error Messages
const String kNetworkError = 'Network error. Please check your connection.';
const String kGenericError = 'Something went wrong. Please try again.';
const String kAuthError = 'Authentication failed. Please try again.';
const String kCartEmpty = 'Your cart is empty.';
const String kProductNotFound = 'Product not found.';
const String kInvalidQuantity = 'Invalid quantity.';
const String kOutOfStock = 'Product is out of stock.';

// Success Messages
const String kAddedToCart = 'Added to cart successfully!';
const String kRemovedFromCart = 'Removed from cart successfully!';
const String kOrderPlaced = 'Order placed successfully!';
const String kProfileUpdated = 'Profile updated successfully!';

// Permissions
const List<String> kRequiredPermissions = ['camera', 'storage', 'location'];

// Navigation Labels
const String kNavLabelHome = 'Home';
const String kNavLabelProfile = 'Profile';
const String kNavLabelSettings = 'Settings';
const String kNavLabelOrders = 'Orders';
const String kNavLabelFavorites = 'Favorites';
const String kNavLabelCart = 'Cart';
const String kNavLabelCategories = 'Categories';
const String kNavLabelSearch = 'Search';
