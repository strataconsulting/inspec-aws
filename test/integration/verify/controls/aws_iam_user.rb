describe aws_iam_user('mfa_not_enabled_user') do
  it { should_not have_mfa_enabled }
  it { should_not have_console_password }
  its('console_password_last_used') { should be_nil }
end

describe aws_iam_user('console_password_enabled_user') do
  it { should have_console_password }
  its('console_password_last_used') { should be_nil }
end

describe aws_iam_user('credekop') do
  its('console_password_last_used') { should be > Time.now - 90 * 86400}
  its(:access_key_count ) { should be < 5 }
end
