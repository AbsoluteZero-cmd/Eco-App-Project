import 'package:flutter/material.dart';

import '../constants.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  late PageController _pageController;
  String? _dropdownOption;
  late List<DropdownMenuItem<String>> sortingOptions;

  @override
  initState(){
    super.initState();

    sortingOptions = [
      DropdownMenuItem(child: Text('Option1'), value: '1',),
      DropdownMenuItem(child: Text('Option2'), value: '2',),
      DropdownMenuItem(child: Text('Option3'), value: '3',),
    ];

    _pageController = PageController(initialPage: 2, viewportFraction: 0.8);
  }

  _plantSelector(index) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.3),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(kBorderRadius)
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding * 1.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                  'Plants archive',
                  style: TextStyle(
                    fontSize: kFontTitle,
                  ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton<String>(
                  hint: Text('Select sorting option'),
                  isExpanded: true,
                  items: sortingOptions,
                  value: _dropdownOption,
                  onChanged: (value) {
                      setState(() {
                        _dropdownOption = value;
                      });
                  },
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                  // padEnds: false,
                  controller: _pageController,
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _plantSelector(index);
                  }),
            )
          ],
        ),
      );
  }
}

