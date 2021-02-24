import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';
import 'FirstScreen.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Directory externalDir  = Platform.isIOS ? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
 String path = externalDir.path.toString() + "/Log.txt";

  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [ConsoleHandler()]);


   /// CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
   ///   EmailManualHandler(["mobile-test-mail@mail.ru"]) ]);
   // Directory externalDir = await getExternalStorageDirectory();

   CatcherOptions releaseOptions =  CatcherOptions(DialogReportMode(),  [FileHandler(File(path))],
      localizationOptions: [
        LocalizationOptions("ru",
            notificationReportModeTitle: "Ошибка",
            notificationReportModeContent:
            "Нажмите здесь, чтобы отправить отчет",
            dialogReportModeTitle: "Ошибка",
            dialogReportModeDescription:
            "В приложении произошла непредвиденная ошибка. Пожалуйста, нажмите Принять, для создания отчета об ошибке или Отмена, чтобы не сохранять отчет.",
            dialogReportModeAccept: "Принять",
            dialogReportModeCancel: "Отмена",
            pageReportModeTitle: "Ошибка",
            pageReportModeDescription:
            "В приложении произошла непредвиденная ошибка. Пожалуйста, нажмите Принять, для создания отчета об ошибке или Отмена, чтобы не сохранять отчет.",
            pageReportModeAccept: "Принять",
            pageReportModeCancel: "Отмена")
      ]);
  // Catcher(FirstScreen(), debugConfig: debugOptions, releaseConfig:  releaseOptions);

 runApp( FirstScreen());
}



