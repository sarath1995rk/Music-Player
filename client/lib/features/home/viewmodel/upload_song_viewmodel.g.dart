// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_song_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UploadSongViewmodel)
final uploadSongViewmodelProvider = UploadSongViewmodelProvider._();

final class UploadSongViewmodelProvider
    extends $NotifierProvider<UploadSongViewmodel, AsyncValue<SongModel>?> {
  UploadSongViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadSongViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadSongViewmodelHash();

  @$internal
  @override
  UploadSongViewmodel create() => UploadSongViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SongModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SongModel>?>(value),
    );
  }
}

String _$uploadSongViewmodelHash() =>
    r'59f566ae007fbfa694cae53d727e9d14ae0e8d12';

abstract class _$UploadSongViewmodel extends $Notifier<AsyncValue<SongModel>?> {
  AsyncValue<SongModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SongModel>?, AsyncValue<SongModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SongModel>?, AsyncValue<SongModel>?>,
              AsyncValue<SongModel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
