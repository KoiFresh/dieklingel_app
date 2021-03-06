import 'package:flutter/cupertino.dart';

import '../../components/ice_configuration.dart';
import '../../components/simple_alert_dialog.dart';
import '../../views/home_view.dart';

import '../../globals.dart' as app;

class IceConfigurationViewPage extends StatelessWidget {
  IceConfigurationViewPage({
    Key? key,
    this.configuration,
  }) : super(key: key) {
    urlsController.text = configuration?.urls ?? "";
    usernameController.text = configuration?.username ?? "";
    credentialController.text = configuration?.credential ?? "";
  }

  final TextEditingController urlsController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController credentialController = TextEditingController();
  final IceConfiguration? configuration;

  void addConfiguration(BuildContext context) async {
    if (urlsController.text.isEmpty) {
      await displaySimpleAlertDialog(
        context,
        const Text("Error"),
        const Text("Please enter a url"),
      );
      return;
    }

    IceConfiguration configuration = this.configuration ??
        IceConfiguration(
          urls: urlsController.text,
        );
    configuration.urls = urlsController.text;
    configuration.username = usernameController.text;
    configuration.credential = credentialController.text;

    List<IceConfiguration> configurations = app.iceConfigurations;
    if (configurations.contains(configuration)) {
      int index = configurations.indexOf(configuration);
      configurations.remove(configuration);
      configurations.insert(index, configuration);
    } else {
      configurations.add(configuration);
    }
    app.iceConfigurations = configurations;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text("dieKlingel"),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            CupertinoFormSection.insetGrouped(
              header: const Text("Stun/Turn"),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Text("Url"),
                  placeholder: "stun:stun.dieklingel.com:3478",
                  controller: urlsController,
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Text("Username"),
                  placeholder: "Max",
                  controller: usernameController,
                ),
                CupertinoTextFormFieldRow(
                  prefix: const Text("Credential"),
                  controller: credentialController,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CupertinoButton.filled(
                child: const Text("Save"),
                onPressed: () {
                  addConfiguration(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
