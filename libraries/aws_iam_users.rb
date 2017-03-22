# author: Alex Bedley
# author: Steffanie Freeman
# author: Jeffrey Lyons
# author: Simon Varlow

class AwsIamUsers < Inspec.resource(1)
  name 'aws_iam_users'
  desc 'Verifies settings for AWS IAM users'
  example "
    describe users.where(has_console_password?: true).entries do
      its('is_mfa_enabled?') { should be true }
    end
  "
  def initialize(conn = AWSConnection.new)
    @iam_resource = conn.iam_resource
  end

  filter = FilterTable.create
  filter.add_accessor(:where)
    .add_accessor(:entries)
    .add(:has_console_password?, field: 'x')
    .add(:is_mfa_enabled?, field: 'is_mfa_enabled?')
    .connect(self, :burnthis)

  def burnthis
     return [{'is_mfa_enabled?' => true, 'x' => true}]
  end
end
