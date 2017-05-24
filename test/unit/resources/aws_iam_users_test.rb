# author: Adnan Duric
# author: Steffanie Freeman
require 'aws_iam_users'

class AwsIamUsersTest < Minitest::Test

  def setup
    @mock_user_provider = Minitest::Mock.new
    @user_list = [{name: "test1", has_mfa_enabled?: true},
    {name: "test2", has_mfa_enabled?: true},
    {name: "test3", has_mfa_enabled?: true}]
  end

  def test_mfa_enabled_returns_true_for_all_users_if_mfa_enabled
    @mock_user_provider.expect :list_users, @user_list
    user_collection = AwsIamUsers.new(@mock_user_provider)
    user_collection.users.each do |user| 
      assert user.has_mfa_enabled?
    end
  end

end