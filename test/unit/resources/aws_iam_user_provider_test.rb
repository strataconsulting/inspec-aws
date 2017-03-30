# author: Simon Varlow
# author: Jeffrey Lyons
require 'aws-sdk'
require 'helper'

require 'aws_iam_user'

class AwsIamUserProvider < Minitest::Test
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
end