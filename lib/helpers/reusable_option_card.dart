import 'package:flutter/material.dart';


class ReusableOptionCard extends StatelessWidget {
  const ReusableOptionCard({Key? key,this.iconColor,this.text,this.icon,this.onTap}) : super(key: key);
  final String? text;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? iconColor;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text!,style: TextStyle(fontSize: 18),),
            MaterialButton(
              onPressed: onTap!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
