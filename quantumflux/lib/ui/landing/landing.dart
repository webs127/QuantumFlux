import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantumkey/controller/app_controller.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/manager/image_manager.dart';
import 'package:quantumkey/ui/kyber/landing/kyber_landing.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<AppController>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.black,
        title: Text(
          "Quantum Flux",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorManager.textBlue,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.iconColorStart,
                  ColorManager.iconColorend,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 32,
              width: 32,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(ImageManager.icon, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorManager.settings,
              ),
              child: SizedBox(
                height: 40,
                width: 32,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Image.asset(
                    ImageManager.settings,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const KyberLandingPage(),
                ),
              );
            },
            icon: Icon(Icons.vpn_key),
          ),
        ],
      ),
      backgroundColor: ColorManager.black,
      body: SizedBox(
        height: size.height,
        width: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomContainer(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantum Status",
                        style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 6),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: ColorManager.green,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          Text(
                            "Active",
                            style: TextStyle(color: ColorManager.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Entropy Level",
                        style: TextStyle(color: ColorManager.textGrey),
                      ),
                      Text(
                        "${(data.entropyLevel).toStringAsFixed(2)}%",
                        style: TextStyle(color: ColorManager.textBlue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: data.entropyLevel / 100,
                    minHeight: 8,
                    color: ColorManager.textBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              CustomContainer(
                children: [
                  Text(
                    "Generate Quantum Password",
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Password Length",
                    style: TextStyle(
                      color: ColorManager.textWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Slider(
                          padding: EdgeInsets.zero,
                          value: data.passwordStrength,
                          max: data.max,
                          min: data.min,
                          activeColor: ColorManager.textBlue,
                          onChanged: data.onPasswordStrengthChanged,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        (data.passwordStrength).toStringAsFixed(0),
                        style: TextStyle(
                          color: ColorManager.textBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckBox(value: true, text: "Numbers"),
                          CustomCheckBox(value: false, text: "Symbols"),
                          CustomCheckBox(value: false, text: "Uppercase"),
                          CustomCheckBox(value: true, text: "Lowercase"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckBox(
                            onChanged: data.onTypeChanged,
                            value: data.uint8,
                            text: "Uint8",
                          ),
                          CustomCheckBox(
                            onChanged: data.onTypeChanged,
                            value: !data.uint8,
                            text: "Uint16",
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      data.getData(5, "uint8");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.iconColorStart,
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: ColorManager.iconColorend,
                            spreadRadius: 2,
                            blurRadius: 8,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.iconColorStart,
                            ColorManager.iconColorend,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: data.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 23,
                                  height: 26,
                                  child: Image.asset(ImageManager.icon),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Generate Quantum Password",
                                  style: TextStyle(
                                    color: ColorManager.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomContainer(
                    margin: EdgeInsets.zero,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Generated Password",
                            style: TextStyle(
                              color: ColorManager.textGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              data.copyToClipBoard(context);
                            },
                            child: SizedBox(
                              width: 20,
                              height: 28,
                              child: Image.asset(ImageManager.copy),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SelectableText(
                        data.generatedQuantumValue,
                        style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Strength",
                            style: TextStyle(
                              color: ColorManager.textGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Container(
                                margin: EdgeInsets.only(right: 2),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: ColorManager.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              data.passwords.isEmpty
                  ? SizedBox()
                  : CustomContainer(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Passwords",
                              style: TextStyle(
                                color: ColorManager.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 28,
                              child: InkWell(
                                onTap: () {
                                  data.clearAll();
                                },
                                child: Image.asset(ImageManager.recent),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: List.generate(
                            data.passwords.length,
                            (i) => CustomContainer(
                              margin: EdgeInsets.only(bottom: 6, top: 16),
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        data.passwords[i]['password'],
                                        style: TextStyle(
                                          color: ColorManager.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      height: 28,
                                      child: Image.asset(ImageManager.copy),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Entropy: ${data.passwords[i]['entropy']}%",
                                  style: TextStyle(
                                    color: ColorManager.textGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${data.passwords[i]['timestamp']}",
                                  style: TextStyle(
                                    color: ColorManager.textGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              CustomContainer(
                children: [
                  Text(
                    "Security Settings",
                    style: TextStyle(
                      color: ColorManager.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: List.generate(
                      3,
                      (i) => SettingsTile(
                        title: data.settings[i].title,
                        subTitle: data.settings[i].subTitle,
                        active: data.settings[i].active,
                        onChanged: (value) {
                          data.onSettingsChanged(value, i);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool active;
  final Function(bool?)? onChanged;
  const SettingsTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.active,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subTitle,
                style: TextStyle(
                  color: ColorManager.textGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Checkbox(
            value: active,
            activeColor: ColorManager.textBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final String text;
  final Function(bool?)? onChanged;
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: ColorManager.textBlue,
          value: value,
          onChanged: (value) {},
        ),
        Text(
          text,
          style: TextStyle(
            color: ColorManager.textBlue,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  const CustomContainer({super.key, required this.children, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      margin: margin ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.containerStart, ColorManager.containerEnd],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
