import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fluttertaladsod/domain/report/i_report_repository.dart';
import 'package:fluttertaladsod/domain/report/report.dart';
import 'package:fluttertaladsod/domain/report/report_failure.dart';
import 'package:get/get.dart';

class ReportRepository implements IReportRepository {
  FirebaseFirestore get _firestore => Get.find();

  @override
  Future<Either<ReportFailure, Unit>> sendReport(Report r) async {
    try {
      final data = r.toJson();
      await _firestore
          .collection('reports')
          .doc(r.id)
          .set(data)
          .timeout(
            Duration(seconds: 5),
            onTimeout: () => left(ReportFailure.timeout()),
          );
      return right(unit);
    } catch (err) {
      return left(ReportFailure.unexpected(err));
    }
  }
}
