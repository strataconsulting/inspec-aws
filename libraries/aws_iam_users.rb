# author: Alex Bedley
# author: Steffanie Freeman
class AwsIamUsers < Inspec.resource(1)
  name 'aws_iam_users'
  desc 'Verifies settings for AWS IAM users'
  example ''

  def initialize(aws_user_provider = AwsIam::UserProvider.new,
                 user_factory = AwsIamUserFactory.new)
    @users = aws_user_provider.list_users
    @user_factory = user_factory
  end

  def users
    @users.map { |user|
      @user_factory.create_user(user)
    }
  end

  class AwsIamUserFactory
    def create_user(user)
      AwsIamUser.new(user: user)
    end
  end
end