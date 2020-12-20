import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissionForStorageAndMicrophone() async {
  final micPermission = await Permission.microphone.request();
  final storagePermission = await Permission.storage.request();
  print(
      'Permissions => Microphone: $micPermission, Storage: $storagePermission');

  if (micPermission == PermissionStatus.granted &&
      storagePermission == PermissionStatus.granted) {
    return true;
  }

  if (micPermission == PermissionStatus.denied ||
      storagePermission == PermissionStatus.denied) {
    return requestPermissionForStorageAndMicrophone();
  }

  if (micPermission == PermissionStatus.permanentlyDenied ||
      storagePermission == PermissionStatus.permanentlyDenied) {
    print('Permissions => Opening App Settings');
    openAppSettings();
  }
  return false;
}
