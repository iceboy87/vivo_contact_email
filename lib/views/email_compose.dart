import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../controllers/email_controller.dart';

class EmailComposePage extends StatefulWidget {
  final String toAddress;

  EmailComposePage({required this.toAddress, Key? key}) : super(key: key);

  @override
  State<EmailComposePage> createState() => _EmailComposePageState();
}

class _EmailComposePageState extends State<EmailComposePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController toAddressController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  late final EmailController emailController;

  bool _isLoading = false;
  List<File> attachments = [];

  @override
  void initState() {
    super.initState();
    emailController = EmailController(context: context);
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _pickFiles() {
    emailController.pickFiles((files) {
      setState(() {
        attachments = files;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose Email')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("From: "),
                    Text(FirebaseAuth.instance.currentUser?.email ?? 'Unknown'),
                  ],
                ),
                SizedBox(height: 0.5.h),
                const Text("To:"),
                TextField(
                  controller: toAddressController,
                  decoration: const InputDecoration(labelText: 'Enter Email'),
                ),
                SizedBox(height: 1.h),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 1.h),
                TextField(
                  controller: messageController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Attach Files'),
                    ),
                    if (attachments.isNotEmpty)
                      Text('${attachments.length} file(s) attached'),
                  ],
                ),
                SizedBox(height: 1.h),
                Center(
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                emailController.sendCustomEmail(
                                  toAddress: toAddressController.text,
                                  subject: subjectController.text,
                                  emailBody: messageController.text,
                                  attachments: attachments,
                                  onLoading: (isLoading) {
                                    setState(() {
                                      _isLoading = isLoading;
                                    });
                                  },
                                );
                              }
                            },
                            child: const Text('Send 👍'),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _EmailComposePageState extends State<EmailComposePage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController toAddressController = TextEditingController();
//   final TextEditingController subjectController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();
//   late final EmailController emailController;
//
//   bool _isLoading = false;
//   List<File> attachments = [];
//
//   @override
//   void initState() {
//     super.initState();
//     emailController = EmailController(context: context);
//   }
//
//   @override
//   void dispose() {
//     subjectController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }
//
//   // Future<void> pickFiles() async {
//   //   final permissionStatus = await Permission.storage.status;
//   //
//   //   if (permissionStatus.isGranted) {
//   //     FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //       allowMultiple: true,
//   //     );
//   //
//   //     if (result != null) {
//   //       setState(() {
//   //         attachments = result.paths.map((path) => File(path!)).toList();
//   //       });
//   //     }
//   //   } else if (permissionStatus.isDenied) {
//   //     PermissionStatus newStatus = await Permission.storage.request();
//   //     if (newStatus.isGranted) {
//   //       pickFiles();
//   //     } else if (newStatus.isPermanentlyDenied) {
//   //       _showPermissionDialog();
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Storage permission denied')),
//   //       );
//   //     }
//   //   } else if (permissionStatus.isPermanentlyDenied) {
//   //     _showPermissionDialog();
//   //   }
//   // }
//   //
//   // void _showPermissionDialog() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text('Permission Required'),
//   //       content: const Text(
//   //           'Storage permission is required to attach files. Please enable it in the app settings.'),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           child: const Text('Cancel'),
//   //         ),
//   //         TextButton(
//   //           onPressed: () async {
//   //             Navigator.pop(context);
//   //             await openAppSettings();
//   //           },
//   //           child: const Text('Open Settings'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Compose Email')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Text("From: "),
//                     Text(FirebaseAuth.instance.currentUser?.email ?? 'Unknown'),
//                   ],
//                 ),
//                 SizedBox(height: 0.5.h),
//                 const Text("To:"),
//                 TextField(
//                   controller: toAddressController,
//                   decoration: const InputDecoration(labelText: 'Enter Email'),
//                 ),
//                 SizedBox(height: 1.h),
//                 TextField(
//                   controller: subjectController,
//                   decoration: const InputDecoration(
//                     labelText: 'Subject',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 TextField(
//                   controller: messageController,
//                   maxLines: 6,
//                   decoration: const InputDecoration(
//                     labelText: 'Message',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: pickFiles,
//                       icon: const Icon(Icons.attach_file),
//                       label: const Text('Attach Files'),
//                     ),
//                     if (attachments.isNotEmpty)
//                       Text('${attachments.length} file(s) attached'),
//                   ],
//                 ),
//                 SizedBox(height: 1.h),
//                 Center(
//                   child:
//                       _isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 emailController.sendCustomEmail(
//                                   toAddress: toAddressController.text,
//                                   subject: subjectController.text,
//                                   emailBody: messageController.text,
//                                   attachments: attachments,
//                                   onLoading: (isLoading) {
//                                     setState(() {
//                                       _isLoading = isLoading;
//                                     });
//                                   },
//                                 );
//                               }
//                             },
//                             child: const Text('Send 👍'),
//                           ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
