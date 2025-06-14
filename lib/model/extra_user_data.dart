
class ExtraUserData{
  final UserData? userData;
  final GovData? govData;
  final GovId? govId;
  final Location? location;
  final BusinessData? businessData;
  final String? address;
  final Map<String, dynamic>? metadata;

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
    }..removeWhere((key, value) => value == null);
  }

  static ExtraUserData fromMap(Map<String, dynamic> map) {
    return ExtraUserData(
      userData: map['userData'] != null ? UserData.fromMap(map['userData']) : null,
      govData: map['govData'] != null ? GovData.fromMap(map['govData']) : null,
      govId: map['govId'] != null ? GovId.fromMap(map['govId']) : null,
      location: map['location'] != null ? Location.fromMap(map['location']) : null,
      businessData: map['businessData'] != null ? BusinessData.fromMap(map['businessData']) : null,
      address: map['address'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }
}

class UserData {
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? email;

  UserData({this.firstName, this.lastName, this.dob, this.email});

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'email': email,
    }..removeWhere((key, value) => value == null);
  }

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      firstName: map['first_name'],
      lastName: map['last_name'],
      dob: map['dob'],
      email: map['email'],
    );
  }
}

class GovData {
  final String? bvn;
  final String? dl;
  final String? nin;
  final String? vnin;

  GovData({this.bvn, this.dl, this.nin, this.vnin});

  Map<String, dynamic> toJson() {
    return {
      'bvn': bvn,
      'dl': dl,
      'nin': nin,
      'vnin': vnin,
    }..removeWhere((key, value) => value == null);
  }

  static GovData fromMap(Map<String, dynamic> map) {
    return GovData(
      bvn: map['bvn'],
      dl: map['dl'],
      nin: map['nin'],
      vnin: map['vnin'],
    );
  }
}

class GovId {
  final String? national;
  final String? passport;
  final String? dl;
  final String? voter;
  final String? nin;
  final String? others;

  GovId({this.national, this.passport, this.dl, this.voter, this.nin, this.others});

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

  static GovId fromMap(Map<String, dynamic> map) {
    return GovId(
      national: map['national'],
      passport: map['passport'],
      dl: map['dl'],
      voter: map['voter'],
      nin: map['nin'],
      others: map['others'],
    );
  }
}

class Location {
  final String? latitude;
  final String? longitude;

  Location({this.latitude, this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    }..removeWhere((key, value) => value == null);
  }

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class BusinessData {
  final String? cac;

  BusinessData({this.cac});

  Map<String, dynamic> toJson() {
    return {
      'cac': cac,
    }..removeWhere((key, value) => value == null);
  }

  static BusinessData fromMap(Map<String, dynamic> map) => BusinessData(cac: map['cac']);
}

