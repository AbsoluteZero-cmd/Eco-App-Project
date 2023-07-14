import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart';
import '../navigation.dart';

class HistoryItemEditPage extends StatefulWidget {
  final HistoryItem historyItem;
  HistoryItemEditPage({required this.historyItem, super.key});

  @override
  State<HistoryItemEditPage> createState() => _HistoryItemEditPageState();
}

class _HistoryItemEditPageState extends State<HistoryItemEditPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _titleController.text = widget.historyItem.title;
    _descriptionController.text = widget.historyItem.description;

    print('my item ${widget.historyItem}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: 1.5 * kDefaultPadding),
        child: Column(
          children: [
            Text('Форма',
                style: TextStyle(
                    fontSize: kFontTitle, fontWeight: FontWeight.bold)),
            TextField(
              textDirection: TextDirection.ltr,
              controller: _titleController,
              maxLines: 1,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: 'Вид растения',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (text) {
                _titleController.text = text;
              },
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Описание болезни',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (text) {
                _descriptionController.text = text;
              },
            ),
            _isLoading
                ? LinearProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await uploadHistoryChanges(widget.historyItem.id);
                    },
                    child: Text('Изменить'))
          ],
        ),
      ),
    );
  }

  Future<void> uploadHistoryChanges(String id) async {
    setState(() {
      _isLoading = true;
    });

    String? uid = Auth().currentUser?.uid.toString();

    DatabaseReference reference =
        FirebaseDatabase.instance.ref('/history/${uid}/${id}');

    await reference.update({
      "title": _titleController.text,
      "description": _descriptionController.text,
    });

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => Navigation()));
  }
}
