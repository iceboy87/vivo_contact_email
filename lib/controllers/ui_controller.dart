import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/crud_services.dart';
import 'auth_services.dart';

class HomepageController {
  late Stream<QuerySnapshot> stream;

  HomepageController() {
    stream = CRUDService().getContacts();
  }

  Stream<QuerySnapshot> getContactsStream({String? searchQuery}) {
    return CRUDService().getContacts(searchQuery: searchQuery);
  }

  void callUser(String phone) async {
    String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  void sendMessage(String phone) async {
    String url = "sms:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  // void emailMessage(BuildContext context, String? email) async {
  //   if (email == null || email.isEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("Email is not available")));
  //     return;
  //   }
  //
  //   final Uri emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     query:
  //     'subject=${Uri.encodeComponent('Hello!')}&body=${Uri.encodeComponent('I wanted to reach out to you.')}',
  //   );
  //
  //   if (await canLaunchUrl(emailLaunchUri)) {
  //     await launchUrl(emailLaunchUri);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Could not launch email app")),
  //     );
  //   }
  // }

  void logout(BuildContext context) {
    AuthService().logout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Logged Out")));
    Navigator.pushReplacementNamed(context, "/login");
  }
}