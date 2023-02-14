import 'package:easy_logger/easy_logger.dart';

class ABAPayment {
  static EasyLogger logger = EasyLogger(
    name: 'aba_payment',
    defaultLevel: LevelMessages.debug,
    enableBuildModes: [BuildMode.debug, BuildMode.profile, BuildMode.release],
    enableLevels: [
      LevelMessages.debug,
      LevelMessages.info,
      LevelMessages.error,
      LevelMessages.warning
    ],
  );
}
