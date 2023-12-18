class UserModel {
  String name;
  String email;
  String phone;
  String id;
  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.id});

  UserModel copyWith(
          {String? name, String? email, String? phone, String? id}) =>
      UserModel(
          name: name ?? this.name,
          email: email ?? this.email,
          phone: phone ?? this.phone,
          id: id ?? this.id);
  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      id: map['id']);
  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'phone': phone, 'id': id};
}
