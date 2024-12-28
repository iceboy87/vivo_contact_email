import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../controllers/crud_services.dart';
import 'home.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({
    super.key,
    required this.docID,
    required this.name,
    required this.phone,
    required this.email,
  });
  final String docID, name, phone, email;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _nameController.text = widget.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Contact")),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 2.h),
                SizedBox(
                  height: 7.h,
                  width: 90.w,
                  child: TextFormField(
                    validator:
                        (value) => value!.isEmpty ? "Enter any name" : null,
                    controller: _nameController,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text;
                        return newValue.copyWith(
                          text:
                          text.isNotEmpty
                              ? text[0].toUpperCase() + text.substring(1)
                              : '',
                          selection: newValue.selection,
                        );
                      }),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Name"),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 7.h,
                  width: 90.w,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Phone"),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 7.h,
                  width: 90.w,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 6.h,
                  width: 90.w,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.green.shade400,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        CRUDService().updateContact(
                          _nameController.text,
                          _phoneController.text,
                          _emailController.text,
                          widget.docID,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                        );
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}