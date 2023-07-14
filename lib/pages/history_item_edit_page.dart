import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController _heightController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;
  String? _status;
  int? _age, _height;

  @override
  void initState() {
    _titleController.text = widget.historyItem.title;
    _descriptionController.text = widget.historyItem.description;
    _heightController.text = widget.historyItem.height.toString();
    _ageController.text = widget.historyItem.age.toString();

    _status = widget.historyItem.status;
    _age = widget.historyItem.age;
    _height = widget.historyItem.height;

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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.4 * kDefaultPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Высота (м)',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        _height = int.parse(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Возраст (лет)',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        _age = int.parse(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton(
              value: _status,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: HistoryItem.statusList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            TextField(
              maxLines: 1,
              maxLength: 30,
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Вид растения',
              ),
            ),
            TextField(
              maxLines: 5,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание болезни',
                border: OutlineInputBorder(),
              ),
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
      "height": int.parse(_heightController.text),
      "age": int.parse(_ageController.text),
      "status": _status,
    });

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
        context, PageRouteBuilder(pageBuilder: (_, __, ___) => Navigation()));
  }
}
