class LeaveRequest {
  late final String id;
  final String type;
  final String startDate;
  final String endDate;
  final String reason;
  late final String status;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });
}
