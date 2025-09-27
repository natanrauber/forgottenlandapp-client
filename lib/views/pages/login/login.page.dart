import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../controllers/user_controller.dart';
import '../../../theme/colors.dart';
import '../../widgets/src/buttons/buttons.widget.dart';
import '../../widgets/src/fields/custom_text_field.widget.dart';
import '../../widgets/src/other/app_page.dart';
import '../../widgets/src/other/better_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController userCtrl = Get.find<UserController>();

  bool switchSignup = false;

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'login',
        body: Obx(
          () => Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _body(),
          ),
        ),
      );

  Widget _body() {
    if (userCtrl.isLoggedIn.value) return _signoutBody();
    if (userCtrl.code != null) return _verifyAccBody();
    if (switchSignup) return _signupBody();
    return _signinBody();
  }

  Widget _signupBody() => Column(
        children: <Widget>[
          _title('Sign up'),
          const SizedBox(height: 16),
          _nameInput(),
          const SizedBox(height: 16),
          _passwordInput(),
          const SizedBox(height: 16),
          _confirmPasswordInput(),
          const SizedBox(height: 16),
          _signupButton(),
          const SizedBox(height: 16),
          _errorText(),
          const SizedBox(height: 16),
          _switchButton(),
        ],
      );

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(left: 3),
        child: SelectableText(text),
      );

  CustomTextField _nameInput() => CustomTextField(
        loading: userCtrl.isLoading.isTrue,
        label: 'Character name',
        controller: userCtrl.nameCtrl,
        keyboardType: TextInputType.emailAddress,
        onChanged: (_) {
          if (userCtrl.error != null) {
            userCtrl.error = null;
            setState(() {});
          }
        },
      );

  CustomTextField _passwordInput() => CustomTextField(
        loading: userCtrl.isLoading.isTrue,
        label: 'Password',
        controller: userCtrl.passwordCtrl,
        obscureText: true,
        onChanged: (_) {
          if (userCtrl.error != null) {
            userCtrl.error = null;
            setState(() {});
          }
        },
      );

  CustomTextField _confirmPasswordInput() => CustomTextField(
        loading: userCtrl.isLoading.isTrue,
        label: 'Confirm password',
        controller: userCtrl.confirmPasswordCtrl,
        obscureText: true,
        onChanged: (_) {
          if (userCtrl.error != null) {
            userCtrl.error = null;
            setState(() {});
          }
        },
      );

  PrimaryButton _signupButton() => PrimaryButton(
        text: 'Sign up',
        isLoading: userCtrl.isLoading.value,
        onTap: userCtrl.signup,
      );

  Widget _errorText() => Text(
        userCtrl.error?.value ?? '',
        style: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          color: AppColors.red,
        ),
      );

  Widget _switchButton() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            switchSignup = !switchSignup;
            userCtrl.nameCtrl.clear();
            userCtrl.passwordCtrl.clear();
            userCtrl.confirmPasswordCtrl.clear();
            setState(() {});
          },
          child: BetterText(
            switchSignup ? 'Already registered? <u>Sign in<u>' : 'Not registered? <u>Sign up<u>',
            selectable: false,
            style: const TextStyle(
              color: AppColors.blue,
              decorationColor: AppColors.blue,
            ),
          ),
        ),
      );

  Widget _verifyAccBody() => Column(
        children: <Widget>[
          _title('Verify account'),
          const SizedBox(height: 16),
          _codeInfoText1(),
          const SizedBox(height: 16),
          _exampleButton(),
          const SizedBox(height: 16),
          _codeText(),
          const SizedBox(height: 16),
          _infoText(),
          const SizedBox(height: 16),
          _codeInfoText2(),
          const SizedBox(height: 16),
          _verifyButton(),
          const SizedBox(height: 16),
          _errorText(),
        ],
      );

  Widget _codeInfoText1() => const BetterText(
        'Copy and paste the following code into your character comment on Tibia.com to verify your account.',
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      );

  Widget _exampleButton() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString('https://www.tibia.com/community/?subtopic=characters&name=Awaken'),
          child: const BetterText(
            '<u>See example<u>',
            selectable: false,
            style: TextStyle(
              color: AppColors.blue,
              decorationColor: AppColors.blue,
            ),
          ),
        ),
      );

  Widget _codeText() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgPaper,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BetterText(
                userCtrl.code?.value ?? '',
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: userCtrl.code?.value ?? ''));
                userCtrl.info = 'Copied!'.obs;
                setState(() {});
              },
              child: const Icon(
                Icons.copy,
              ),
            ),
          ),
        ],
      );

  Widget _infoText() => Text(
        userCtrl.info?.value ?? '',
        style: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          color: AppColors.green,
        ),
      );

  Widget _codeInfoText2() => const BetterText(
        'It may take a while for the comment to update. You can remove the comment after the verification.',
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      );

  Widget _verifyButton() => PrimaryButton(
        text: userCtrl.verified.value ? 'Sign in' : 'Verify',
        isLoading: userCtrl.isLoading.value,
        color: userCtrl.verified.value ? AppColors.green : null,
        onTap: () {
          if (userCtrl.verified.value) {
            userCtrl.nameCtrl.clear();
            userCtrl.passwordCtrl.clear();
            userCtrl.confirmPasswordCtrl.clear();
            userCtrl.info = null;
            userCtrl.error = null;
            userCtrl.code = null;
            userCtrl.verified = false.obs;
            switchSignup = false;
            setState(() {});
            return;
          }
          userCtrl.info = null;
          userCtrl.error = null;
          setState(() {});
          userCtrl.verify();
        },
      );

  Widget _signinBody() => Column(
        children: <Widget>[
          _title('Sign in'),
          const SizedBox(height: 16),
          _nameInput(),
          const SizedBox(height: 16),
          _passwordInput(),
          const SizedBox(height: 16),
          _signinButton(),
          const SizedBox(height: 16),
          _errorText(),
          const SizedBox(height: 52),
          _switchButton(),
        ],
      );

  Widget _signoutBody() => Column(
        children: <Widget>[
          _userInfo(),
          const SizedBox(height: 16),
          _signoutButton(),
        ],
      );

  Widget _userInfo() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Text('User: ${userCtrl.data?.value.name ?? ''}'),

            const SizedBox(height: 10),

            Text('Status: ${userCtrl.data?.value.subscriber == true ? 'Premmium Account' : 'Free Account'}'),
          ],
        ),
      );

  PrimaryButton _signinButton() => PrimaryButton(
        text: 'Sign in',
        isLoading: userCtrl.isLoading.value,
        onTap: userCtrl.signin,
      );

  PrimaryButton _signoutButton() => PrimaryButton(
        text: 'Sign out',
        isLoading: userCtrl.isLoading.value,
        onTap: userCtrl.signout,
      );
}
