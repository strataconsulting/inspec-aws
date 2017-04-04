# author: Simon Varlow
# author: Jeffrey Lyons
require 'aws-sdk'
require 'helper'

require 'aws_iam_user'

class AwsIamUserProviderTest < Minitest::Test
Username = "test" 
   
   def setup
   	@mock_iam_reasource = Minitest::Mock.new
   	@mock_aws_connection = Minitest::Mock.new 
   	@mock_aws_connection.expect :iam_resource, @mock_iam_reasource
   	@user_provider = AwsIamUserProvider.new(@mock_aws_connection)
   end

   def test_get_user
   	@mock_iam_reasource.expect :user, {}, [Username]
   	assert !@user_provider.get_user(Username).nil?
   end

   def test_that_MFA_enable_returns_true_if_MFA_Enabled?
    @mock_user = Minitest::Mock.new
    @mock_user.expect :mfa_devices, [true]
    @mock_iam_reasource.expect :user, @mock_user, [Username]
    assert !@user_provider.has_mfa_enabled(Username)
   end 

   def test_that_MFA_enable_returns_false_if_MFA_Enabled?
    @mock_user = Minitest::Mock.new
    #@mock_user.expect :mfa_devices, [false]
    @mock_iam_reasource.expect :user, @mock_user, [Username]
    assert !@user_provider.has_mfa_enabled(Username)
   end
end