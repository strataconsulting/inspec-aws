# author: Simon Varlow
# author: Jeffrey Lyons
# author: Steffanie Freeman
# author: Alex Bedley
require 'aws-sdk'
require 'helper'

require 'aws_iam_user_provider'

class AwsIamUserProviderTest < Minitest::Test
Username = "test"

  def setup
    @mock_iam_resource = Minitest::Mock.new
    @mock_aws_connection = Minitest::Mock.new
    @mock_aws_connection.expect :iam_resource, @mock_iam_resource
    @user_provider = AwsIamUserProvider.new(@mock_aws_connection)
  end

  def test_get_user
    @mock_iam_resource.expect :user, create_mock_user, [Username]
    assert !@user_provider.get_user(Username).nil?
  end

  def test_has_mfa_enabled_returns_true
    @mock_iam_resource.expect :user, create_mock_user(has_mfa_enabled: true), [Username]
    assert @user_provider.get_user(Username)[:has_mfa_enabled?]
  end

  def test_has_mfa_enabled_returns_false
    @mock_iam_resource.expect :user, create_mock_user(has_mfa_enabled: false), [Username]
    assert !@user_provider.get_user(Username)[:has_mfa_enabled?]
  end
  
  def test_has_console_password_returns_true
    @mock_iam_resource.expect :user, create_mock_user(has_console_password: true), [Username]
    assert @user_provider.get_user(Username)[:has_console_password?]
  end

  def test_has_console_password_returns_false
    @mock_iam_resource.expect :user, create_mock_user(has_console_password: false), [Username]
    assert !@user_provider.get_user(Username)[:has_console_password?]
  end
  
  def test_has_console_password_returns_false_when_nosuchentity
    mock_user = Minitest::Mock.new
    mock_login_profile = Minitest::Mock.new
    
    mock_user.expect :mfa_devices, []
    
    mock_login_profile.expect :create_date, nil do |args|
      raise Aws::IAM::Errors::NoSuchEntity.new nil, nil
    end
    mock_user.expect :login_profile, mock_login_profile
    @mock_iam_resource.expect :user, mock_user, [Username]
    
    assert !@user_provider.get_user(Username)[:has_console_password?]
  end
  
  def test_has_console_password_throws
    mock_user = Minitest::Mock.new
    mock_login_profile = Minitest::Mock.new
    
    mock_user.expect :mfa_devices, []
    
    mock_login_profile.expect :create_date, nil do |args|
      raise ArgumentError
    end
    mock_user.expect :login_profile, mock_login_profile
    
    @mock_iam_resource.expect :user, mock_user, [Username]
    
    assert_raises ArgumentError do
      @user_provider.get_user(Username)
    end
  end

  def create_mock_user(has_console_password: true, has_mfa_enabled: true)
    mock_user = Minitest::Mock.new
    mock_login_profile = Minitest::Mock.new
    
    mock_user.expect :mfa_devices, has_mfa_enabled ? ['device'] : []
    
    mock_login_profile.expect :create_date, has_console_password ? 'date' : nil
    mock_user.expect :login_profile, mock_login_profile
  end
end
