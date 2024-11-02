import 'package:powersync/powersync.dart';

// No need to create pk id, powersync automatically detects this

const assessmentsTable = Table('assessments', [
  Column.text('prepared_by'),
  Column.text('approved_by'),
  Column.text('assessment_type'),
  Column.text('title'),
  Column.integer('total_questions'),
  Column.integer('is_approved'),
  Column.text('start_time'),
  Column.text('dead_line'),
  Column.integer('duration_mins'),
  Column.text('status'),
  Column.text('created_at'),
  Column.text('updated_at'),
]);