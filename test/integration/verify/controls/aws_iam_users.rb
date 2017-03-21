=begin
describe aws_iam_users() do
  its('has_mfa_enabled?') { should be false }
  its('has_console_password?') { should be false }
end

describe aws_iam_users() do
  its('has_console_password?') { should be true }
end

=end
describe users.where(has_console_password?: true).entries do
   its('is_mfa_enabled?') { should be true }
end