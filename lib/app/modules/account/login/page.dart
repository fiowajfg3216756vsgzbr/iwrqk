import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../routes/pages.dart';
import 'controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  final FocusNode blankNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.cancel();
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).login,
        ),
      ),
      body: Center(
        child: Form(
          key: controller.formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/app_icon.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: controller.emailController,
                    validator: (input) {
                      if (input != null) {
                        if (input.isNotEmpty &&
                            controller.emailRegExp.hasMatch(input)) {
                          return null;
                        } else {
                          return L10n.of(context)
                              .message_please_type_valid_email;
                        }
                      }
                      return L10n.of(context).message_please_type_email;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FontAwesomeIcons.solidEnvelope),
                      labelText: L10n.of(context).email,
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (input) => controller.email = input,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.passwordVisibility,
                      cursorColor: Theme.of(context).primaryColor,
                      validator: (input) {
                        if (input == null) {
                          return L10n.of(context).message_please_type_password;
                        }
                        if (input.length < 6) {
                          return L10n.of(context)
                              .message_login_password_longer_than_6;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.togglePasswordVisibility();
                          },
                          child: Icon(
                            controller.passwordVisibility
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: L10n.of(context).password,
                      ),
                      onSaved: (input) => controller.password = input,
                      focusNode: focusNode,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(blankNode);
                            Get.toNamed(AppRoutes.register);
                          },
                          child: Text(
                            L10n.of(context).register,
                            style: const TextStyle(fontSize: 17.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15)),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(blankNode);
                            controller.login(context);
                          },
                          child: Text(
                            L10n.of(context).login,
                            style: const TextStyle(fontSize: 17.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
