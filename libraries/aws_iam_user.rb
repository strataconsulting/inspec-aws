# author: Alex Bedley
# author: Steffanie Freeman
# author: Simon Varlow
class AwsIamUser < Inspec.resource(1)
  name 'aws_iam_user'
  desc 'Verifies settings for AWS IAM user'
  example "
    describe aws_iam_user('test_user_name') do
      it { should_not have_mfa_enabled }
      it { should have_console_password }
    end
  "
  def initialize(name, conn = AWSConnection.new)
    @name = name
    @iam_resource = conn.iam_resource
    @iam_client = conn.iam_client
    @user = @iam_resource.user(@name)
  end

  def has_mfa_enabled?
    !@user.mfa_devices.first.nil?
  end

  def has_console_password?
    return !@user.login_profile.create_date.nil?
  rescue Aws::IAM::Errors::NoSuchEntity
    return false
  end

  def console_password_last_used
    @user.password_last_used
  end

  def has_access_key_0?
    access_keys.length > 0
  end

  def has_access_key_1?
    access_keys.length > 1
  end

  def has_active_access_key_0?
    has_access_key_0? && "Active".eql?(access_keys[0].status)
  end

  def has_active_access_key_1?
    has_access_key_1? && "Active".eql?(access_keys[1].status)
  end

  def access_key_last_used_0
    has_access_key_0? ? access_keys_last_used[0].last_used_date || access_keys[0].create_date : nil
  end

  def access_key_last_used_1
    has_access_key_1? ? access_keys_last_used[1].last_used_date || access_keys[1].create_date : nil
  end

  def access_keys
    @access_keys ||= @user.access_keys.entries.sort {|x,y| x.create_date <=> y.create_date }
  end

  def access_keys_last_used
    @access_keys_last_used ||= access_keys.map {|x| @iam_client.get_access_key_last_used({access_key_id: x.access_key_id}).access_key_last_used }
  end
end

