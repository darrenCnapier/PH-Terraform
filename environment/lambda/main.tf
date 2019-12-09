resource "aws_iam_role" "iam_for_lambda" {
  name = "PH_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_role_attach" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

data "archive_file" "zip" {
  type = "zip"
  source {
    content = "def handler(event:, context:)\n  # TODO implement \nend"
    filename = "default.rb"
  }
  output_path = "default.zip"
}


resource "aws_lambda_function" "appointment_reminders" {
  filename = data.archive_file.zip.output_path
  function_name = "appointment_reminders"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "dwh_app_reminder_job.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = ""
      PGDATABASE = ""
      PGUSER = ""
      PGPASSWORD = ""
      IVINEX_UNAME = ""
      IVINEX_PWD = ""
      CL_UNAME = ""
      CL_PWD = ""
      GM_ADR = ""
      GM_PWD = ""
      APP_ROOT = ""
      IVINEX_DATA = ""
      RUBYLIB = ""
      TW_SID = ""
      TW_TOKEN = ""
      TW_FROM = ""
    }
  }
}

resource "aws_lambda_function" "copay" {
  filename = data.archive_file.zip.output_path
  function_name = "copay"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "dwh_copay_rpt_job.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = ""
      PGDATABASE = ""
      PGUSER = ""
      PGPASSWORD = ""
      IVINEX_UNAME = ""
      IVINEX_PWD = ""
      CL_UNAME = ""
      CL_PWD = ""
      GM_ADR = ""
      GM_PWD = ""
      APP_ROOT = ""
      IVINEX_DATA = ""
      RUBYLIB = ""
      TW_SID = ""
      TW_TOKEN = ""
      TW_FROM = ""
    }
  }
}

resource "aws_lambda_function" "issues" {
  filename = data.archive_file.zip.output_path
  function_name = "issues"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "dwh_issue_rpt_job.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = ""
      PGDATABASE = ""
      PGUSER = ""
      PGPASSWORD = ""
      IVINEX_UNAME = ""
      IVINEX_PWD = ""
      CL_UNAME = ""
      CL_PWD = ""
      GM_ADR = ""
      GM_PWD = ""
      APP_ROOT = ""
      IVINEX_DATA = ""
      RUBYLIB = ""
      TW_SID = ""
      TW_TOKEN = ""
      TW_FROM = ""
    }
  }
}

resource "aws_lambda_function" "points" {
  filename = data.archive_file.zip.output_path
  function_name = "points"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "dwh_points_rpt_job.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = ""
      PGDATABASE = ""
      PGUSER = ""
      PGPASSWORD = ""
      IVINEX_UNAME = ""
      IVINEX_PWD = ""
      CL_UNAME = ""
      CL_PWD = ""
      GM_ADR = ""
      GM_PWD = ""
      APP_ROOT = ""
      IVINEX_DATA = ""
      RUBYLIB = ""
      TW_SID = ""
      TW_TOKEN = ""
      TW_FROM = ""
    }
  }
}

