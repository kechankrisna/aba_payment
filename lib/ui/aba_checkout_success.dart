import 'package:aba_payment/service/strings.dart';
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
                Strings.paymentSuccessfullyLabel,
                style: themeData.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                Strings.paymentProcceedSuccessfullyLabel,
                textAlign: TextAlign.center,
              ),
              Text(
                Strings.moreDetailLabel,
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
                      Strings.homeLabel,
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
