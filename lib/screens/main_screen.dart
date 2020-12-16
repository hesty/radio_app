import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_app/models/radio_model.dart';
import 'package:radio_app/utils/ai_util.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:alan_voice/alan_voice.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<RadioModel> radios;

  RadioModel selectedRadio;
  Color selectedColor;
  bool isPlaying = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchRadios();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
      setState(() {});
    });
    initAlan();
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = RadioModelList.fromJson(radioJson).radios;
    selectedRadio = radios[0];
    selectedColor = Color(int.tryParse(selectedRadio.color));
    setState(() {});
  }

  initAlan() {
    AlanVoice.addButton(
        "c522c206cc55d2f8b33edec2b7d4023d2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => handleCommand(command.data));
  }

  handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        playMusic(selectedRadio.url);
        break;
      case "stop":
        audioPlayer.stop();
        break;
      case "next":
        final index = selectedRadio.id;
        RadioModel newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        playMusic(newRadio.url);
        break;
      case "prev":
        final index = selectedRadio.id;
        RadioModel newRadio;
        if (index - 1 <= 0) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        playMusic(newRadio.url);
        break;
      default:
        print("Response---" + response["command"]);
        break;
    }
  }

  playMusic(String url) {
    audioPlayer.play(url);
    selectedRadio = radios.firstWhere((elemnt) => elemnt.url == url);
    print(selectedRadio.name);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: selectedColor ?? AIColors.primaryColor2,
          child: radios != null
              ? [
                  100.heightBox,
                  "All Channels".text.xl.white.semiBold.make().px16(),
                  20.heightBox,
                  ListView(
                    padding: Vx.m0,
                    shrinkWrap: true,
                    children: radios
                        .map((e) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(e.icon),
                            ),
                            title: "${e.name} FM".text.white.make(),
                            subtitle: e.tagline.text.white.make()))
                        .toList(),
                  ).expand()
                ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(colors: [
                AIColors.primaryColor2,
                selectedColor ?? AIColors.primaryColor1
              ], begin: Alignment.topLeft, end: Alignment.bottomRight))
              .make(),
          [
            AppBar(
              title: "Hesty Radio".text.xl4.bold.white.make().shimmer(
                  primaryColor: Colors.white38, secondaryColor: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ).h(100).p16(),
            20.heightBox,
          ].vStack(),
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios.length,
                  aspectRatio: 1,
                  onPageChanged: (index) {
                    selectedRadio = radios[index];
                    if (isPlaying) {
                      playMusic(selectedRadio.url);
                    }
                    final colorHex = radios[index].color;
                    selectedColor = Color(int.tryParse(colorHex));
                    setState(() {});
                  },
                  enlargeCenterPage: true,
                  itemBuilder: (context, index) {
                    final rad = radios[index];

                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: VxBox(
                                  child: rad.category.text.uppercase.white
                                      .make()
                                      .px32())
                              .height(40)
                              .alignCenter
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              rad.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              rad.tagline.text.sm.white.semiBold.make()
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              "Double tap to Play".text.gray300.make()
                            ].vStack())
                      ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                            image: NetworkImage(rad.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)))
                        .border(color: Colors.black54, width: 5)
                        .withRounded(value: 60)
                        .make()
                        .onInkDoubleTap(() {
                      playMusic(rad.url);
                    }).p16();
                  },
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
                  alignment: Alignment.bottomCenter,
                  child: [
                    if (isPlaying)
                      "Playing Now - ${selectedRadio.name} FM "
                          .text
                          .white
                          .makeCentered(),
                    Icon(
                      isPlaying
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_outline,
                      color: Colors.white,
                      size: 50,
                    ).onInkTap(() {
                      if (isPlaying) {
                        audioPlayer.stop();
                      } else {
                        playMusic(selectedRadio.url);
                      }
                    })
                  ].vStack())
              .pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
