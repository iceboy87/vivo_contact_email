import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:permission_handler/permission_handler.dart';

class EmailController {
  final BuildContext context;

  EmailController({required this.context});

  Future<void> sendCustomEmail({
    required String toAddress,
    required String subject,
    required String emailBody,
    required void Function(bool) onLoading,
    required List<File> attachments,
  }) async {
    final String? fromAddress = FirebaseAuth.instance.currentUser?.email;

    if (fromAddress == null) {
      _showSnackBar(message: 'User is not logged in!', isError: true);
      return;
    }

    final smtpServer = gmail(
      fromAddress,
      "exoe cfmw iylu huip", //enter your 2-factor authentication password.

      // Go to "(Form address)" email => security => app passwords => register "Email" => copy password.
    );

    final emailMessage =
        Message()
          ..from = Address(fromAddress)
          ..recipients.add(toAddress)
          ..subject = subject
          ..text = emailBody;
    for (File file in attachments) {
      emailMessage.attachments.add(FileAttachment(file));
    }

    onLoading(true);

    try {
      final sendReport = await send(emailMessage, smtpServer);
      print('Message sent: $sendReport');
      _showSnackBar(message: 'Email sent successfully!');
    } catch (e) {
      print('Error occurred: $e');
      _showSnackBar(message: 'Failed to send email: $e', isError: true);
    } finally {
      onLoading(false);
    }
  }

  void _showSnackBar({required String message, bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }


  List<File> attachments = [];
  bool isLoading = false;

  Future<void> pickFiles(Function(List<File>) onFilesPicked) async {
    final permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      // Permission already granted
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        attachments = result.paths.map((path) => File(path!)).toList();
        onFilesPicked(attachments);
      }
    } else if (permissionStatus.isDenied) {
      // Request permission
      PermissionStatus newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        // Permission granted after request
        pickFiles(onFilesPicked); // Call again to pick files
      } else if (newStatus.isPermanentlyDenied) {
        // Show dialog to guide the user to settings
        _showPermissionDialog();
      } else {
        // Permission still denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      // Directly show the dialog for permanently denied
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Storage permission is required to attach files. Please enable it in the app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
