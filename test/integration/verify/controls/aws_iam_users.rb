describe aws_iam_users.where( 'has_console_password?' => true ) do
  its('has_mfa_enabled?') { should eq [true] }
end
