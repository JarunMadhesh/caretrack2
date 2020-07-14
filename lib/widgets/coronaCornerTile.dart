import 'package:flutter/material.dart';

class CoronaCornerTile extends StatefulWidget {
  final String title;
  final String content;
  final bool isOpen;

  CoronaCornerTile(this.title, this.content, this.isOpen);

  @override
  _CoronaCornerTileState createState() => _CoronaCornerTileState();
}

class _CoronaCornerTileState extends State<CoronaCornerTile> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      width: _width,
      child: Container(
        constraints: BoxConstraints(minHeight: 58, maxWidth: _width * 0.81),
        margin:  const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
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
          alignment: Alignment.centerLeft,
          padding:  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'RalewayMed',
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff8b3365),
                  ),
                ),
              ),
              if (widget.isOpen) const SizedBox(height: 15),
              if (widget.isOpen)
                Text(
                  widget.content,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff000000),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
