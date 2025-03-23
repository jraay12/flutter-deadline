class TaskModel {
  final int id;
  final String title;
  final String status; // Can be "pending" or "completed"
  final String dueDate;
  final String time;

  TaskModel({
    required this.id,
    required this.title,
    required this.status,
    required this.dueDate,
    required this.time,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      dueDate: json['dueDate'] ?? '',
      time: json['time'] ?? '',
    );
  }


}
