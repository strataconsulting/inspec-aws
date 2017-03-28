# author: Alex Bedley
# author: Steffanie Freeman
# author: Jeffrey Lyons
# author: Simon Varlow

class AwsIamUsers < Inspec.resource(1)
  name 'aws_iam_users'
  desc 'Verifies settings for AWS IAM users'
  example "
    describe aws_iam_users.where( 'has_console_password?' => true ) do
      its('has_mfa_enabled?') { should eq [true] }
    end
  "
  def initialize(conn = AWSConnection.new)
    @iam_resource = conn.iam_resource
  end

  filter = FilterTable.create
  filter
    .add_accessor(:where)
    .add_accessor(:entries)
    .add(:has_console_password?, field: 'has_console_password?')
    .add(:has_mfa_enabled?, field: 'has_mfa_enabled?')
    .connect(self, :get_users)

  def get_users
    return [
      {'has_mfa_enabled?' => true, 'has_console_password?' => true},
      {'has_mfa_enabled?' => true, 'has_console_password?' => false},
      {'has_mfa_enabled?' => false, 'has_console_password?' => false}
    ]
  end
end
