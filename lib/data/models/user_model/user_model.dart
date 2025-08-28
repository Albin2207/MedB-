class UserDetails {
  final String? id;
  final String? userId;
  final String? clinicId;
  final String? doctorId;
  final dynamic doctorClinics;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? age;
  final String? gender;
  final String? designation;
  final String email;
  final String contactNo;
  final String? address;
  final String? city;
  final String? district;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? profilePicture;

  UserDetails({
    this.id,
    this.userId,
    this.clinicId,
    this.doctorId,
    this.doctorClinics,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.age,
    this.gender,
    this.designation,
    required this.email,
    required this.contactNo,
    this.address,
    this.city,
    this.district,
    this.state,
    this.country,
    this.postalCode,
    this.profilePicture,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      clinicId: json['clinicId']?.toString(),
      doctorId: json['doctorId']?.toString(),
      doctorClinics: json['doctorClinics'],
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age']?.toString(),
      gender: json['gender'],
      designation: json['designation'],
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      address: json['address'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'clinicId': clinicId,
      'doctorId': doctorId,
      'doctorClinics': doctorClinics,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'designation': designation,
      'email': email,
      'contactNo': contactNo,
      'address': address,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'profilePicture': profilePicture,
    };
  }

  String get fullName => '$firstName $middleName $lastName'.trim();
}