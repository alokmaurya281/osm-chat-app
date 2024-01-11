import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/modules/home/controllers/home_controller.dart';
import 'package:osm_chat/widgets/chat_user_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // print(APIS.auth.currentUser);
    return GetBuilder<HomeController>(builder: (contrller) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () {
            if (controller.isSearching) {
              // setState(() {
              //   isSearching = !isSearching;
              // });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: mainScaffoldHome(context),
        ),
      );
    });
  }

  Widget mainScaffoldHome(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: controller.isSearching
              ? TextFormField(
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  autofocus: true,
                  onChanged: (value) {
                    // setState(() {
                    //   searchList.clear(); // Clear the previous search results

                    //   for (var element in list) {
                    //     if (element.name
                    //             .toLowerCase()
                    //             .contains(value.toLowerCase()) ||
                    //         element.email
                    //             .toLowerCase()
                    //             .contains(value.toLowerCase())) {
                    //       if (!searchList.contains(element)) {
                    //         searchList.add(element);
                    //       }
                    //     }
                    // }
                    // });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Name or Email.....'),
                )
              : const Text('Osm Chat'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  // setState(() {
                  //   isSearching = !isSearching;
                  // });
                },
                icon: controller.isSearching
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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Status'),
              Tab(text: 'Calls'),
            ],
          ),
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
                  //   Navigator.pop(context);
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //     return const ProfileScreen();
                  //   }));
                },
                title: const Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                onTap: () async {
                  // await signout();
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
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return const AddUserDialog();
              //     });
            },
            child: const Icon(
              Icons.add_comment_outlined,
              color: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
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
                              List list = data
                                      ?.map((e) => ChatUser.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              return ListView.builder(
                                padding: const EdgeInsets.only(top: 8),
                                physics: const BouncingScrollPhysics(),
                                // itemCount: controller.isSearching
                                // ? controller.length
                                // :
                                // list.length,
                                itemBuilder: (context, index) {
                                  return ChatUserCardWidget(
                                    // user: controller.isSearching
                                    // ? searchList[index]
                                    // :
                                    user: list[index],
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
            Center(
              child: Text('No Status'),
            ),

            // Contents of Tab 3
            Center(
              child: Text('No Call History'),
            ),
          ],
        ),
      ),
    );
  }
}