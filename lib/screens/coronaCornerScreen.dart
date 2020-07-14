import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import '../widgets/coronaCornerTile.dart';
import '../widgets/videoplayer.dart';

class CoronaCorner extends StatefulWidget {
  static const route = '/coronaCorner';

  final qAndA = [
    [
      'Should I worry about COVID-19?',
      'Illness due to COVID-19 infection is generally mild, especially for children and young adults. However, it can cause serious illness: about 1 in every 5 people who catch it need hospital care. It is therefore quite normal for people to worry about how the COVID-19 outbreak will affect them and their loved ones.'
    ],
    [
      'Are antibiotics effective in treating COVID-19?',
      'No. Antibiotics do not work against viruses, they only work on bacterial infections. COVID-19 is caused by a virus, so antibiotics do not work. Antibiotics should not be used as a means of prevention or treatment of COVID-19. They should only be used as directed by a physician to treat a bacterial infection'
    ],
    [
      'Can people who recover from COVID-19 be infected again?',
      'We know that for similar coronaviruses, infected people are unlikely to be re-infected shortly after they recover. However, because the immune response to COVID-19 is not yet understood, it is not yet known whether similar immune protection will be observed for patients who have recovered from COVID-19.'
    ],
    [
      'Does COVID-19 need treatment?',
      'Around 80% of people who get COVID-19 will recover without needing special treatment at home, and usually within around seven days. Most people will only have mild symptoms similar to the common cold. Around one in six people will become severely ill and develop difficulty breathing, in which case they will need hospital care. In serious cases COVID-19 can cause pneumonia'
    ],
    [
      'Can COVID-19 be cured?',
      '''There’s no proven cure for COVID-19, but most people will recover fully without needing medical treatment.\nIf you’re unwell with COVID-19, resting, drinking lots of liquids, and  other home remedies can help with symptoms.\nIf your symptoms don’t improve after seven days or if you have difficulty breathing and persistent pain in your chest, call your local health service immediately.'''
    ],
    [
      'What is the risk of my child becoming sick with COVID-19?',
      'Based on available evidence, children do not appear to be at higher risk for COVID-19 than adults. While some children and infants have been sick with COVID-19, adults make up most of the known cases to date.'
    ]
  ];

  @override
  _CoronaCornerState createState() => _CoronaCornerState();
}

class _CoronaCornerState extends State<CoronaCorner> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAEBF3),
      appBar: NeuAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xff8b3365),
        ),
        title: const Text(
          'Corona Corner',
          style: const TextStyle(
            fontFamily: 'RalewayMed',
            fontWeight: FontWeight.w500,
            color: const Color(0xff8b3365),
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.qAndA.length + 1,
          itemBuilder: (ctx, i) {
            i -= 1;
            if (i == -1) {
              return NeuCard(
                curveType: CurveType.flat,
                bevel: 12,
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: 40,
                  bottom: 20,
                ),
                decoration: NeumorphicDecoration(
                    borderRadius: BorderRadius.circular(20)),
                child: AssetVideo(),
              );
            }
            return GestureDetector(
              onTap: () {
                if (selectedIndex == i) {
                  selectedIndex = -1;
                } else {
                  selectedIndex = i;
                }

                setState(() {});
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: CoronaCornerTile(
                    widget.qAndA[i][0], widget.qAndA[i][1], selectedIndex == i),
              ),
            );
          },
        ),
      ),
    );
  }
}
