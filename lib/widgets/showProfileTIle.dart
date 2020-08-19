import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../providers/profile.dart';

class ProfileTile extends StatelessWidget {
  final Profile profile;

  ProfileTile(this.profile);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      margin:  const EdgeInsets.only(top: 25),
      constraints: BoxConstraints(minHeight: 325, maxWidth: _width * 0.77),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-5.0, -5.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xffEAEBF3),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Name ',
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff000000),
                ),
              ),
            ),
        const SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(minHeight: 46),
              padding:  const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(-5.0, -5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(5.0, 5.0),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffEAEBF3),
              ),
              child: AutoSizeText(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 21,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff8b3365),
                ),
              ),
            ),
        const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Date of birth ',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                const SizedBox(height: 15),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: 46, maxWidth: _width * 0.39),
                      padding:  const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(-5.0, -5.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(5.0, 5.0),
                            blurRadius: 10.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffEAEBF3),
                      ),
                      child: AutoSizeText(
                        DateFormat.yMMMd().format(profile.dob),
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 21,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff8b3365),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Age',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                const SizedBox(height: 15),
                    Container(
                      constraints: BoxConstraints(minHeight: 46),
                      padding:  const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(-5.0, -5.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(5.0, 5.0),
                            blurRadius: 10.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffEAEBF3),
                      ),
                      child: AutoSizeText(
                        profile.age.toString(),
                        style: const TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 21,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff8b3365),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'mobile Number',
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff000000),
                ),
              ),
            ),
        const SizedBox(height: 15),
            Container(
              constraints: BoxConstraints(minHeight: 46),
              padding:  const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(-5.0, -5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(5.0, 5.0),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffEAEBF3),
              ),
              child: AutoSizeText(
                ' ${profile.phoneNumber.toString()}',
                style: const TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 21,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff8b3365),
                ),
              ),
            ),
          ],
        ),
        padding:  const EdgeInsets.all(25),
      ),
    );
  }
}
