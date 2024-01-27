class User{
  static String Id = " ";
  static String username = " ";
  static String Name = "";
  static String Shift = "";
  String name = " ";
  String id = " ";
  String shift = " ";
  String email = "";
  String contact = "";
  String cnic = "";
  String address = "";
  String birthDate = "";
  String Designation = "";
  static String profilePic = " ";
  static bool canEdit = true;
  static String textHolder = "Check In";
  static bool canCheck = true;
  static int time = 0;
  static int timer = 0;
  static String designation = "";


  User(
      {
        required this.name,
        required this.id,
        required this.shift,
        required this.cnic,
        required this.contact,
        required this.email,
        required this.address,
        required this.birthDate,
        required this.Designation
      }
      );
}