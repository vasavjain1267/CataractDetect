
class Result {
  final String rightEyeResult;
  final String leftEyeResult;
  late final String rightEyeImagePath;
  late final String leftEyeImagePath;
  final DateTime dateTime;
  
  Result({
    required this.rightEyeResult,
    required this.leftEyeResult,
    required this.rightEyeImagePath,
    required this.leftEyeImagePath,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'rightEyeResult': rightEyeResult,
      'leftEyeResult': leftEyeResult,
      'righteyeimage': rightEyeImagePath,
      'lefteyeimage': leftEyeImagePath,
      'dateTime': dateTime.toIso8601String(),
    };
  }
   void updateImagePaths({required String rightPath, required String leftPath}) {
    rightEyeImagePath = rightPath;
    leftEyeImagePath = leftPath;
  }
  static Result fromMap(Map<String, dynamic> map) {
    return Result(
      rightEyeResult: map['rightEyeResult']??'',
      leftEyeResult: map['leftEyeResult']??'',
      rightEyeImagePath: map['righteyeimage']??'',
      leftEyeImagePath: map['lefteyeimage']??'',
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
