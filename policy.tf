# Policy document for read-write access to entire bucket (bucket, bucket/*)
data "aws_iam_policy_document" "rw_source_policy_doc" {
  count = length(var.read_write_paths) == 0 ? 0 : 1

  version = "2012-10-17"

  statement {
    sid     = "ReadWritePolicy0"
    effect  = "Allow"
    actions = var.read_write_actions
    resources = [
      "arn:${var.arn_partition}:s3:::${var.dunhumby_s3_bucket}",
      "arn:${var.arn_partition}:s3:::${var.dunhumby_s3_bucket}/*"
    ]
  }
}

# If any read_write_paths are specified, the read-write source policy doc will be
# overwritten by a scoped down bucket resource (bucket/some/path,
# bucket/some/path/*)
data "aws_iam_policy_document" "path_specific_rw_doc" {
  count = length(var.read_write_paths) == 0 ? 0 : 1

  version     = "2012-10-17"
  source_json = data.aws_iam_policy_document.rw_source_policy_doc[0].json

  dynamic "statement" {
    for_each = local.rw_paths_map

    content {
      sid     = "ReadWritePolicy${statement.key}"
      effect  = "Allow"
      actions = var.read_write_actions
      resources = [
        "arn:${var.arn_partition}:s3:::${var.dunhumby_s3_bucket}/${statement.value}",
        "arn:${var.arn_partition}:s3:::${var.dunhumby_s3_bucket}/${statement.value}/*"
      ]
    }
  }
}

# Read-write IAM policy
resource "aws_iam_policy" "rw_policy" {
  count = length(var.read_write_paths) == 0 ? 0 : 1

  name = format("%s-read-write-%s", var.bucket_name, random_string.rand.result)
  # If you want read-write access to the entire bucket, path_specific_rw_doc should not overwrite ReadWritePolicy0 in rw_source_policy_doc
  policy = var.read_write_paths[0] == "" ? data.aws_iam_policy_document.rw_source_policy_doc[0].json : data.aws_iam_policy_document.path_specific_rw_doc[0].json
}
