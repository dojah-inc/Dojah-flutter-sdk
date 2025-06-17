class ExtraUserData {
  final UserData? userData;
  final GovData? govData;
  final GovId? govId;
  final Location? location;
  final BusinessData? businessData;
  final String? address;
  final Map<String, dynamic>? metadata; // Dart's dynamic is similar to Kotlin's Any for JSON-like maps

  ExtraUserData({
    this.userData,
    this.govData,
    this.govId,
    this.location,
    this.businessData,
    this.address,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'userData': userData?.toJson(),
      'govData': govData?.toJson(),
      'govId': govId?.toJson(),
      'location': location?.toJson(),
      'businessData': businessData?.toJson(),
      'address': address,
      'metadata': metadata,
    }..removeWhere((key, value) => value == null); // Remove null values for cleaner JSON
  }
}

class UserData {
  final String? firstName;
  final String? lastName;
  final String? dob; // format: dd-mm-yyy
  final String? email;

  UserData({
    this.firstName,
    this.lastName,
    this.dob,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'email': email,
    }..removeWhere((key, value) => value == null);
  }
}

class GovData {
  final String? bvn;
  final String? dl;
  final String? nin;
  final String? vnin;

  GovData({
    this.bvn,
    this.dl,
    this.nin,
    this.vnin,
  });

  Map<String, dynamic> toJson() {
    return {
      'bvn': bvn,
      'dl': dl,
      'nin': nin,
      'vnin': vnin,
    }..removeWhere((key, value) => value == null);
  }
}

class GovId {
  final String? national;
  final String? passport;
  final String? dl;
  final String? voter;
  final String? nin;
  final String? others;

  GovId({
    this.national,
    this.passport,
    this.dl,
    this.voter,
    this.nin,
    this.others,
  });

  Map<String, dynamic> toJson() {
    return {
      'national': national,
      'passport': passport,
      'dl': dl,
      'voter': voter,
      'nin': nin,
      'others': others,
    }..removeWhere((key, value) => value == null);
  }
}

class Location {
  final String? latitude;
  final String? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    }..removeWhere((key, value) => value == null);
  }
}

class BusinessData {
  final String? cac;

  BusinessData({
    this.cac,
  });

  Map<String, dynamic> toJson() {
    return {
      'cac': cac,
    }..removeWhere((key, value) => value == null);
  }
}