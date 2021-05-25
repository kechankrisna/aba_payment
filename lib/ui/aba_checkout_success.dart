import 'package:flutter/material.dart';

class ABACheckoutSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: themeData.primaryColor,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                "payment successfully",
                style: themeData.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                "${"your subscription was paid successfully"}.",
                textAlign: TextAlign.center,
              ),
              Text(
                "${"for more detail, go to dashboard and check status of user profile"}.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/"),
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "dashboard",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
