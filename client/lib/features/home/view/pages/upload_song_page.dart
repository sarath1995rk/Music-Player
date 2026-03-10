import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utilities/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/upload_song_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  Color _selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      uploadSongViewmodelProvider.select((val) => val?.isLoading == true),
    );
    ref.listen(uploadSongViewmodelProvider, (previous, next) {
      next?.whenOrNull(
        data: (data) =>
            showSnackBar(context: context, content: "Song uploaded!"),
        error: (e, st) => showSnackBar(context: context, content: e.toString()),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.check),
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(uploadSongViewmodelProvider.notifier)
                    .uploadSong(
                      song: selectedAudio!,
                      thumbnail: selectedImage!,
                      artist: _artistController.text.trim(),
                      songName: _songNameController.text.trim(),
                      hexCode: _selectedColor.hex,
                    );
              } else {
                showSnackBar(
                  context: context,
                  content: "All fields are required",
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => selectImage(),
                  child: selectedImage != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),

                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : DottedBorder(
                          options: RectDottedBorderOptions(
                            color: Pallete.borderColor,
                            strokeWidth: 2,
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                          ),

                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open, size: 40),
                                const SizedBox(height: 15),
                                Text(
                                  "Select the thumbnail for your song",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 40),
                selectedAudio != null
                    ? AudioWave(path: selectedAudio!.path)
                    : CustomField(
                        hintText: "Pick Song",
                        controller: null,
                        readOnly: true,
                        onTap: () => selectAudio(),
                      ),
                const SizedBox(height: 20),
                CustomField(hintText: "Artist", controller: _artistController),
                const SizedBox(height: 20),
                CustomField(
                  hintText: "Song Name",
                  controller: _songNameController,
                ),
                const SizedBox(height: 20),
                ColorPicker(
                  heading: Text("Pick Color"),
                  onColorChanged: (Color color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  color: _selectedColor,
                  pickersEnabled: {ColorPickerType.wheel: true},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
