# author: Simon Varlow
require 'aws-sdk'
require 'helper'

require 'iam'

class TestIAM < Minitest::Test
Username = "test" 
  
  def setup
    @mockConn = Minitest::Mock.new
    @mockUser = Minitest::Mock.new
    @mockResource = Minitest::Mock.new
    @mockProfile = Minitest::Mock.new

    @mockConn.expect :iam_resource, @mockResource
    @mockResource.expect :user, @mockUser, [String]
  end

  def test_that_MFA_enable_returns_true_if_MFA_Enabled
    @mockUser.expect :mfa_devices, ["test"]
    assert Iam.new(Username, @mockConn).is_mfa_enabled?
  end

  def test_that_MFA_enable_returns_false_if_MFA_is_not_Enabled
    @mockUser.expect :mfa_devices, []
    assert !Iam.new(Username, @mockConn).is_mfa_enabled?
  end

  def test_that_console_Password_returns_true_if_console_Password_has_been_set
    @mockUser.expect :login_profile, @mockProfile
    @mockProfile.expect :create_date, "test"
    assert Iam.new(Username, @mockConn).has_console_password?
  end

  def test_that_console_Password_returns_false_if_console_Password_has_not_been_set
    @mockUser.expect :login_profile, @mockProfile
    @mockProfile.expect :create_date, nil
    assert !Iam.new(Username, @mockConn).has_console_password?
  end

  def test_that_console_Password_returns_false_if_console_Password_throws_no_such_entity
    @mockUser.expect :login_profile, @mockProfile
    @mockProfile.expect :create_date, nil do |args|
      raise Aws::IAM::Errors::NoSuchEntity.new nil, nil
    end
    assert !Iam.new(Username, @mockConn).has_console_password?
  end

  def test_that_console_Password_throws_if_console_Password_throws_not_no_such_entity
    @mockUser.expect :login_profile, @mockProfile
    @mockProfile.expect :create_date, nil do |args|
      raise ArgumentError
    end

    assert_raises ArgumentError do
      Iam.new(Username, @mockConn).has_console_password?
    end
  end
end