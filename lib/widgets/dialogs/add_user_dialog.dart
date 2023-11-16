import 'package:flutter/material.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/utils/dialogs.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({
    super.key,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController userController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: SizedBox(
        width: 200,
        height: 150,
        child: Stack(
          children: [
            Text(
              'Add User',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.email,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  width: 260,
                  height: 50,
                  child: TextFormField(
                    controller: userController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter Email Address',
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 130,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (userController.text.isNotEmpty) {
                      Dialogs.showProgressIndicator(context);
                      await APIS
                          .addChatUser(userController.text)
                          .then((value) => {
                                if (value)
                                  {Dialogs.showSnackBar(context, "User Added!")}
                                else
                                  {
                                    Dialogs.showSnackBar(context,
                                        "It seems User doesnt exists!!!")
                                  }
                              });
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Dialogs.showSnackBar(context, "please enter email!");
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
