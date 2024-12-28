import 'package:flutter/material.dart';
import 'package:phone_contact/views/update_contact.dart';
import 'package:sizer/sizer.dart';
import '../controllers/crud_services.dart';
import '../controllers/ui_controller.dart';
import 'email_compose.dart';

class DetailedView extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String docID;

  const DetailedView({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.docID,
  }) : super(key: key);

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  final HomepageController _controller = HomepageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
        actions: [
          IconButton(
            onPressed: () {
              CRUDService().deleteContact(widget.docID);
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => UpdateContact(
                        name: widget.name,
                        phone: widget.phone,
                        email: widget.email,
                        docID: widget.docID,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                child: CircleAvatar(
                  radius: 40,
                  child: Text(
                    widget.name[0],
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Text(
                widget.name,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              widget.email,
              style: TextStyle(color: Colors.grey, fontSize: 15.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              "Phone",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.7.h),
                  child: Text(widget.phone, style: TextStyle(fontSize: 16.sp)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () {
                        _controller.callUser(widget.phone);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        _controller.sendMessage(widget.phone);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmailComposePage(
                                toAddress: widget.email,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.email_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}