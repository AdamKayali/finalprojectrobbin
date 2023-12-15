import 'package:banger_beats/consts/pallete.dart';
import 'package:banger_beats/consts/text_style.dart';
import 'package:banger_beats/controllers/player_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  String formatTime(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                  child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber),
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(Icons.music_note),
                ),
              )),
            ),
            const SizedBox(height: 12),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: Obx(
                () => Column(children: [
                  Text(
                    data[controller.playIndex.value].displayNameWOExt,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: ourStyle(color: bgDarkColor, family: bold, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data[controller.playIndex.value].artist.toString(),
                    style:
                        ourStyle(color: bgDarkColor, family: regular, size: 16),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          formatTime(Duration(
                              seconds: controller.value.value.toInt())),
                          style: ourStyle(color: bgDarkColor),
                        ),
                        Expanded(
                            child: Slider(
                          thumbColor: sliderColor,
                          inactiveColor: bgColor,
                          activeColor: sliderColor,
                          min: const Duration(seconds: 0).inSeconds.toDouble(),
                          max: controller.max.value,
                          value: controller.value.value,
                          onChanged: (newValue) {
                            controller
                                .changeDurationToSeconds(newValue.toInt());
                            newValue = newValue;
                          },
                        )),
                        Text(
                          formatTime(
                              Duration(seconds: controller.max.value.toInt())),
                          style: ourStyle(color: bgDarkColor),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            int prevIndex = controller.playIndex.value - 1;
                            if (prevIndex < 0) {
                              prevIndex = data.length - 1;
                            }
                            controller.playAudio(
                                data[prevIndex].uri, prevIndex);
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 48,
                            color: bgDarkColor,
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            backgroundColor: bgDarkColor,
                            radius: 35,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value
                                    ? const Icon(
                                        Icons.pause,
                                        color: whiteColor,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        color: whiteColor,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            int nextIndex = controller.playIndex.value + 1;
                            if (nextIndex >= data.length) {
                              nextIndex = 0;
                            }
                            controller.playAudio(
                                data[nextIndex].uri, nextIndex);
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 48,
                            color: bgDarkColor,
                          ),
                        ),
                      ])
                ]),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
