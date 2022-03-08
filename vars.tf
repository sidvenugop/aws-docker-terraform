variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "PRIVATE_KEY_PATH" {
  default = "dunhumby-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "dunhumby-key-pair.pub"
}

variable "EC2_USER" {
  default = "ubuntu"
}
variable "AMI" {
  type = "map"

  default {
    eu-west-2 = "ami-jsuhhu27498b"  //random ami id
    us-east-1 = "ami-hsfssf932649"
  }
}

variable "bucket_name" {
  description = "Name of S3 bucket to create."
  default = "dunhumby_bucket"
  type        = string
}

variable "force_destroy" {
  type        = bool
  description = <<EOF
  A boolean that indicates all objects (including any locked objects) should be deleted from the
  bucket so that the bucket can be destroyed without error. These objects are not recoverable.
  EOF
  default     = true
}

variable "read_write_paths" {
  description = "List of paths/prefixes that should be attached to a read-write` policy. Listed path(s) should omit the head bucket."
  type        = list(string)
  default     = []
}

variable "read_write_actions" {
  description = "List of actions that should be permitted by a read-write policy."
  type        = list(string)
  default = [
    "s3:GetBucketLocation",
    "s3:GetBucketCORS",
    "s3:GetObjectVersionForReplication",
    "s3:GetObject",
    "s3:GetBucketTagging",
    "s3:GetObjectVersion",
    "s3:GetObjectTagging",
    "s3:ListMultipartUploadParts",
    "s3:ListBucketByTags",
    "s3:ListBucket",
    "s3:ListObjects",
    "s3:ListObjectsV2",
    "s3:ListBucketMultipartUploads",
    "s3:PutObject",
    "s3:PutObjectTagging",
    "s3:HeadBucket",
    "s3:DeleteObject"
  ]
}
