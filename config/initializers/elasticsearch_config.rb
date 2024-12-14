ENV['ELASTICSEARCH_URL'] = "http://ec2-54-180-183-186.ap-northeast-2.compute.amazonaws.com"
Searchkick.aws_credentials = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION']
}