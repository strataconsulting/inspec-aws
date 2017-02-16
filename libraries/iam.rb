# author: Alex Bedley
# author: Steffanie Freeman
# author: Simon Varlow

class Iam < Inspec.resource(1)
 name 'aws_iam_user'
  desc 'Verifies settings for AWS IAM user'

  example "
    describe aws_iam_user() do

	end
  "

  def initialize(name, conn = AWSConnection.new)
    @name = name
    @iam_resource = conn.iam_resource
    @user = @iam_resource.user(@name)
  end

  def is_mfa_enabled?
    !@user.mfa_devices.first.nil?
  end

  def has_console_password?
    begin 
    	return !@user.login_profile.create_date.nil?
    rescue
    	return false
    end
  end

end