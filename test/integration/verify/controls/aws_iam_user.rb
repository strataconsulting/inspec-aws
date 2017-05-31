describe aws_iam_user(name: 'mfa_not_enabled_user') do
  its('has_mfa_enabled?') { should be false }
  its('has_console_password?') { should be false }
end

describe aws_iam_user(name: 'console_password_enabled_user') do
  its('has_console_password?') { should be true }
end
