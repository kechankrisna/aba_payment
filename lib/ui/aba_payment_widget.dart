import 'dart:io';
import 'package:flutter/material.dart';
import '../enumeration.dart';

const package = "aba_payment";

class ABAPaymentWidget extends StatefulWidget {
  final AcceptPaymentOption value;
  final Function(AcceptPaymentOption value) onChanged;

  const ABAPaymentWidget({Key key, this.value, this.onChanged})
      : super(key: key);
  @override
  _ABAPaymentWidgetState createState() => _ABAPaymentWidgetState();
}

class _ABAPaymentWidgetState extends State<ABAPaymentWidget> {
  AcceptPaymentOption _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image(
            image: AssetImage("assets/images/ic_generic.png", package: package),
            width: 55,
          ),
          title: Text("Credit/Debit Card"),
          subtitle: Container(
            padding: EdgeInsets.only(top: 5),
            child: Image(
              image: AssetImage("assets/images/ic_cards.png", package: package),
              alignment: Alignment.centerLeft,
              height: 25,
            ),
          ),
          trailing: _value == AcceptPaymentOption.cards
              ? Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                )
              : Icon(Icons.lens_outlined),
          onTap: () => _onTap(AcceptPaymentOption.cards),
        ),
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
          ListTile(
            leading: Image(
              image:
                  AssetImage("assets/images/ic_payway.png", package: package),
              width: 55,
            ),
            title: Text("ABA PAYWAY"),
            subtitle: Text("Scan to pay with ABA Mobile"),
            trailing: _value == AcceptPaymentOption.abapay
                ? Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  )
                : Icon(Icons.lens_outlined),
            onTap: () => _onTap(AcceptPaymentOption.abapay),
          ),
        if (Platform.isAndroid || Platform.isIOS)
          ListTile(
            leading: Image(
              image:
                  AssetImage("assets/images/ic_payway.png", package: package),
              width: 55,
            ),
            title: Text("ABA PAY"),
            subtitle: Text("Tap to pay with ABA Mobile"),
            trailing: _value == AcceptPaymentOption.abapay_deeplink
                ? Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  )
                : Icon(Icons.lens_outlined),
            onTap: () => _onTap(AcceptPaymentOption.abapay_deeplink),
          ),
      ],
    );
  }

  _onTap(AcceptPaymentOption value) {
    if (value != _value) {
      setState(() => _value = value);
      widget.onChanged?.call(_value);
    }
  }
}
