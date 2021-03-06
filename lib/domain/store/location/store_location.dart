// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

// Project imports:
import 'package:fluttertaladsod/domain/location/location.dart';
import 'package:fluttertaladsod/domain/store/value_objects.dart';

part 'store_location.freezed.dart';

@immutable
@freezed
abstract class StoreLocation with _$StoreLocation {
  const factory StoreLocation({
    @required StoreAddress address,
    GeoFirePoint geoFirePoint,
    double distanceAway,
  }) = _StoreLocation;

  factory StoreLocation.empty() {
    return StoreLocation(
      address: StoreAddress(''),
    );
  }

  factory StoreLocation.fromLocationDomain(LocationDomain l) {
    return StoreLocation(
      address: StoreAddress(l.placemark.subLocality),
      geoFirePoint: l.geoFirePoint,
    );
  }
}
