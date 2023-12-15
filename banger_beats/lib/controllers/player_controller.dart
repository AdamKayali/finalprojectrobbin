import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var filteredSongs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    checkPermission();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playAudio(String? uri, index) {
    if (index == playIndex.value && isPlaying.value) {
      // Same song is clicked again, and it's already playing
      // Do nothing or handle as needed (e.g., pause/resume)
    } else {
      // Different song is clicked or same song is clicked while it's paused
      playIndex.value = index;
      try {
        audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!)),
        );
        audioPlayer.play();
        isPlaying(true);
        updatePosition();
      } on Exception catch (e) {
        print(e.toString());
      }
    }
  }

  checkPermission() async {
    var perm = await Permission.audio.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}
