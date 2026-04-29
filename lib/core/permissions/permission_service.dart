import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Request storage permission
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Request all required permissions
  static Future<Map<String, bool>> requestAllPermissions() async {
    final results = <String, bool>{};

    // Camera permission
    results['camera'] = await requestCameraPermission();

    // Storage permission
    results['storage'] = await requestStoragePermission();

    // Location permission
    results['location'] = await requestLocationPermission();

    return results;
  }

  // Check if all required permissions are granted
  static Future<bool> checkAllPermissionsGranted() async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;
    final locationStatus = await Permission.location.status;

    return cameraStatus.isGranted &&
        storageStatus.isGranted &&
        locationStatus.isGranted;
  }

  // Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  // Get permission status
  static Future<PermissionStatus> getPermissionStatus(String permission) async {
    switch (permission) {
      case 'camera':
        return await Permission.camera.status;
      case 'storage':
        return await Permission.storage.status;
      case 'location':
        return await Permission.location.status;
      default:
        return PermissionStatus.denied;
    }
  }

  // Handle permission denied
  static Future<void> handlePermissionDenied(String permission) async {
    final status = await getPermissionStatus(permission);

    if (status.isPermanentlyDenied) {
      // Show dialog to open settings
      // This would typically be handled in the UI layer
      await openAppSettings();
    }
  }
}
