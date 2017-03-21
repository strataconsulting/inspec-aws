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
  
  def list_users()
    @iam_resource.users
  end

    filter = FilterTable.create
    filter.add_accessor(:where)
          .add_accessor(:entries)
          .add(:mfa_device, field: :mfa_devices.first.nil?) 
          .add(:console_password, field: :has_console_password?)
    filter.connect(self, :collect_user_details)  

end
