import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../controllers/ui_controller.dart';
import 'contact_details.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final HomepageController _controller = HomepageController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchfocusNode = FocusNode();

  @override
  void dispose() {
    _searchfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width * 8, 80),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 7.h,
              width: 95.w,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _controller.stream = _controller.getContactsStream(
                      searchQuery: value,
                    );
                  });
                },
                focusNode: _searchfocusNode,
                controller: _searchController,
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text("Search"),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _searchfocusNode.unfocus();
                      setState(() {
                        _controller.stream =
                            _controller.getContactsStream();
                      });
                    },
                    icon: const Icon(Icons.close),
                  )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.person_add),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 32,
                    child: Text(
                      FirebaseAuth.instance.currentUser!.email
                          .toString()[0]
                          .toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                ],
              ),
            ),
            ListTile(
              onTap: () => _controller.logout(context),
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(child: Text("No Contacts Found ..."))
              : ListView(
            children:
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return ListTile(
                onTap: () {
                  // Navigate to a detailed view screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailedView(
                        name: data["name"],
                        phone: data["phone"],
                        email: data["email"],
                        docID: document.id,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(child: Text(data["name"][0])),
                title: Text(
                  data["name"].length > 8
                      ? "${data["name"].substring(0, 8)}"
                      : data["name"],
                ),
                //subtitle: Text(data["phone"]),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    _controller.callUser(data["phone"]);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}