import 'package:flutter/material.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/utils/dialogs.dart';

class EditMessageDialog extends StatefulWidget {
  final Message message;
  const EditMessageDialog({
    super.key,
    required this.message,
  });

  @override
  State<EditMessageDialog> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<EditMessageDialog> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.text = widget.message.message;
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
              'Update Message',
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
                  Icons.message,
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
                    controller: messageController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    decoration: const InputDecoration(
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
                    Dialogs.showProgressIndicator(context);
                    await APIS
                        .updateMessage(widget.message, messageController.text)
                        .then((value) => {
                              Navigator.pop(context),
                              Navigator.pop(context),
                            });
                  },
                  child: Text(
                    'Save',
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
