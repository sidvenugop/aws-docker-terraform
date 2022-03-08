locals {
  # If no `read_write_paths` are provided, default to
  # read-only access to the entire bucket
  ro_paths     = length(var.read_only_paths) + length(var.read_write_paths) == 0 ? [""] : var.read_only_paths
  ro_paths_map = { for idx, val in local.ro_paths : idx => val }
  rw_paths_map = { for idx, val in var.read_write_paths : idx => val }
}
    
# Policy document for read-write access to entire bucket (bucket, bucket/*)
data "aws_iam_policy_document" "rw_source_policy_doc" {
  count = length(var.read_write_paths) == 0 ? 0 : 1

  version = "2012-10-17"

  statement {
    sid     = "ReadWritePolicy0"
    effect  = "Allow"
    actions = var.read_write_actions
    
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]  #Give EC2 access to this policy
    }
    
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

resource "aws_iam_role" "s3_readwrite" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = local.role_description
  name               = local.role_name
  tags               = var.additional_role_tags
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_readwrite" {
  policy_arn = aws_iam_policy.s3_rw_policy.arn
  role       = aws_iam_role.s3_readwrite.name
}
