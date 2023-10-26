resource "aws_backup_vault" "elfate7" {
  name = "elfate7_backup_vault"
}

resource "aws_backup_plan" "elfate7" {
  name = "elfate7_backup_plan"

  rule {
    rule_name          = "elfate7_backup_rule"
    target_vault_name  = aws_backup_vault.elfate7.name
    schedule = "cron(0 12 * * ? *)"
    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "backup_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "backup.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "backup_policy_attachment" {
    name = "backup_policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  roles      = [aws_iam_role.backup_role.name]
}

resource "aws_backup_selection" "efs_selection" {
  name         = "efs_selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.elfate7.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "True"
  }
}

resource "aws_backup_selection" "instance_selection_1" {
  name         = "instance_selection_1"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.elfate7.id

  resources   = var.instance_1_id
}

resource "aws_backup_selection" "instance_selection_2" {
  name         = "instance_selection_2"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.elfate7.id

  resources   = var.instance_2_id
}
