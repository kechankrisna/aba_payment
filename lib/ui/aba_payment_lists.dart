import 'dart:io' as io;
import 'package:aba_payment/services/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aba_payment/enumeration.dart';

const package = "aba_payment";

class ABAPaymentLists extends StatefulWidget {
  final ABAPaymentOption? value;
  final Function(ABAPaymentOption? value)? onChanged;

  const ABAPaymentLists({Key? key, this.value, this.onChanged})
      : super(key: key);
  @override
  _ABAPaymentListsState createState() => _ABAPaymentListsState();
}

class _ABAPaymentListsState extends State<ABAPaymentLists> {
  ABAPaymentOption? _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Image(
              image:
                  AssetImage("assets/images/ic_generic.png", package: package),
              width: 55,
            ),
            title: Text(Strings.creditOrDebitCardLabel),
            subtitle: Container(
              padding: EdgeInsets.only(top: 5),
              child: Image(
                image:
                    AssetImage("assets/images/ic_cards.png", package: package),
                alignment: Alignment.centerLeft,
                height: 25,
              ),
            ),
            trailing: _value == ABAPaymentOption.cards
                ? Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  )
                : Icon(Icons.lens_outlined),
            onTap: () => _onTap(ABAPaymentOption.cards),
          ),
          (kIsWeb ||
                  io.Platform.isMacOS ||
                  io.Platform.isWindows ||
                  io.Platform.isLinux)
              ? ListTile(
                  leading: Image(
                    image: AssetImage("assets/images/ic_payway.png",
                        package: package),
                    width: 55,
                  ),
                  title: Text(Strings.abaPaywayLabel),
                  subtitle: Text(Strings.scanToPayWithABAMobileLabel),
                  trailing: _value == ABAPaymentOption.abapay
                      ? Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                        )
                      : Icon(Icons.lens_outlined),
                  onTap: () => _onTap(ABAPaymentOption.abapay),
                )
              : ListTile(
                  leading: Image(
                    image: AssetImage("assets/images/ic_payway.png",
                        package: package),
                    width: 55,
                  ),
                  title: Text(Strings.abaPayLabel),
                  subtitle: Text(Strings.tapToPayWithABAMobileLabel),
                  trailing: _value == ABAPaymentOption.abapay_deeplink
                      ? Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                        )
                      : Icon(Icons.lens_outlined),
                  onTap: () => _onTap(ABAPaymentOption.abapay_deeplink),
                ),
        ],
      ),
    );
  }

  _onTap(ABAPaymentOption value) {
    if (value != _value) {
      setState(() => _value = value);
      widget.onChanged?.call(_value);
    }
  }
}
