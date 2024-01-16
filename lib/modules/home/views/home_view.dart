import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/modules/home/controllers/home_controller.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/widgets/chat_user_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // print(APIS.auth.currentUser);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (controller.isSearching.value) {
            controller.changeSearchMode();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: mainScaffoldHome(context),
      ),
    );
  }

  Widget mainScaffoldHome(BuildContext context) {
    return Obx(
      () {
        return DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              title: controller.isSearching.value
                  ? TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                      autofocus: true,
                      onChanged: (value) {
                        print(controller.isSearching.value);
                        print('Search List ${controller.searchList}');
                        print('toal List ${controller.list}');

                        controller.searchList.clear();
                        // Clear the previous search results

                        for (var element in controller.list) {
                          if (element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              element.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            if (!controller.searchList.contains(element)) {
                              controller.searchList.add(element);
                            }
                          }
                        }
                        // controller.search(value);
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
                      controller.changeSearchMode();
                    },
                    icon: controller.isSearching.value
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
              bottom: const TabBar(
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
                      Get.toNamed(AppRoutes.profile);
                    },
                    title: const Text(
                      'Profile',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await controller.signout(context);
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
                                  controller.list = data
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  return ListView.builder(
                                    padding: const EdgeInsets.only(top: 8),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: controller.isSearching.value
                                        ? controller.searchList.length
                                        : controller.list.length,
                                    itemBuilder: (context, index) {
                                      return ChatUserCardWidget(
                                        user: controller.isSearching.value
                                            ? controller.searchList[index]
                                            : controller.list[index],
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
                const Center(
                  child: Text(
                    'No Status',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Contents of Tab 3
                const Center(
                  child: Text(
                    'No Call History',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
