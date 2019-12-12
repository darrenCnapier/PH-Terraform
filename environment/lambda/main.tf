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

resource "aws_iam_role_policy_attachment" "vpc_role_attach" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
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
  function_name = "issues_${var.env}_job"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "run_lambda.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = var.pg_host
      PGDATABASE = var.pg_database
      PGUSER = var.pg_username
      PGPASSWORD = var.pg_password
      IVINEX_UNAME = var.ivinex_username
      IVINEX_PWD = var.ivinex_password
      CL_UNAME = var.cl_username
      CL_PWD = var.cl_password
      GM_ADR = var.gmail_email
      GM_PWD = var.gmail_password
      APP_ROOT = "."
      IVINEX_DATA = "./data"
      RUBYLIB = "./lib"
      TW_SID = var.twilio_sid
      TW_TOKEN = var.twilio_token
      TW_FROM = var.twilio_from
      CMD = "./dwh_issue_rpt.rb"
    }
  }
}

resource "aws_lambda_function" "points" {
  filename = data.archive_file.zip.output_path
  function_name = "points_${var.env}_job"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "run_lambda.handler"
  memory_size = 256
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "ruby2.5"
  timeout = 120
  vpc_config {
    security_group_ids = var.security_group_ids
    subnet_ids = var.subnet_ids
  }

  lifecycle {
    ignore_changes = ["source_code_hash", "last_modified"]
  }

  environment {
    variables = {
      PGHOST = var.pg_host
      PGDATABASE = var.pg_database
      PGUSER = var.pg_username
      PGPASSWORD = var.pg_password
      IVINEX_UNAME = var.ivinex_username
      IVINEX_PWD = var.ivinex_password
      CL_UNAME = var.cl_username
      CL_PWD = var.cl_password
      GM_ADR = var.gmail_email
      GM_PWD = var.gmail_password
      APP_ROOT = "."
      IVINEX_DATA = "./data"
      RUBYLIB = "./lib:./vendor"
      TW_SID = var.twilio_sid
      TW_TOKEN = var.twilio_token
      TW_FROM = var.twilio_from
      CMD = "dwh_points_rpt.rb"
    }
  }
}

//resource "aws_cloudwatch_event_rule" "points_rule" {
//  name = ""
//  description = "Run weekly, Sundays at 7 PM PST"
//  schedule_expression = "cron(8 3 * * 1)"
//}

//resource "aws_cloudwatch_event_target" "points_rule_target" {
//  rule = aws_cloudwatch_event_rule.points_rule.name
//  target_id = "points_rule_target"
//  arn = aws_lambda_function.points.arn
//}
//
//resource "aws_lambda_permission" "allow_cloudwatch_to_call_points_rule" {
//  statement_id = "PointsAllowExecutionFromCloudWatch"
//  action = "lambda:InvokeFunction"
//  function_name = aws_lambda_function.points.function_name
//  principal = "events.amazonaws.com"
//  source_arn = aws_cloudwatch_event_rule.points_rule.arn
//}
