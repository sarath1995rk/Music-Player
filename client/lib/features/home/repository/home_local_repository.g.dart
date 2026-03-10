// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_local_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeLocalRepository)
final homeLocalRepositoryProvider = HomeLocalRepositoryProvider._();

final class HomeLocalRepositoryProvider
    extends
        $FunctionalProvider<
          HomeLocalRepository,
          HomeLocalRepository,
          HomeLocalRepository
        >
    with $Provider<HomeLocalRepository> {
  HomeLocalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLocalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLocalRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeLocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeLocalRepository create(Ref ref) {
    return homeLocalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeLocalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeLocalRepository>(value),
    );
  }
}

String _$homeLocalRepositoryHash() =>
    r'85890d5a2bdd88edb910f87a100785ac34c906e1';
