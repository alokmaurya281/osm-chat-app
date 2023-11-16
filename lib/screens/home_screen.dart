import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/screens/auth/login_screen.dart';
import 'package:osm_chat/screens/profile_screen.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:osm_chat/widgets/chat_user_card.dart';
import 'package:osm_chat/widgets/dialogs/add_user_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signout() async {
    Dialogs.showProgressIndicator(context);
    await APIS.updateActiveStatus(false);
    await APIS.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) async {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      });
    });
    // ignore: use_build_context_synchronously
  }

  List<ChatUser> list = [];
  final List<ChatUser> searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    APIS.selfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (APIS.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          await APIS.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          await APIS.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: isSearching
                ? TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        searchList.clear(); // Clear the previous search results

                        for (var element in list) {
                          if (element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              element.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            if (!searchList.contains(element)) {
                              searchList.add(element);
                            }
                          }
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name or Email.....'),
                  )
                : const Text('Osm Chat'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                  icon: isSearching
                      ? const Icon(Icons.cancel)
                      : const Icon(
                          Icons.search,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                const DrawerHeader(
                    child: SizedBox(
                  height: 160,
                )),
                ListTile(
                  leading: const Icon(Icons.home),
                  onTap: () {},
                  title: const Text(
                    'Home',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ProfileScreen();
                    }));
                  },
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    await signout();
                  },
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 8),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AddUserDialog();
                    });
              },
              child: const Icon(
                Icons.add_comment_outlined,
                color: Colors.white,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: APIS.getMyContacts(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  final list1 =
                      snapshot.data?.docs.map((e) => e.id).toList() ?? [];
                  if (list1.isNotEmpty) {
                    return StreamBuilder(
                      stream: APIS.getAllUsers(list1),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text('No users found'),
                              );
                            }
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  isSearching ? searchList.length : list.length,
                              itemBuilder: (context, index) {
                                return ChatUserCardWidget(
                                  user: isSearching
                                      ? searchList[index]
                                      : list[index],
                                );
                              },
                            );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No Connection Found',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
