url = "http://ec2-54-180-183-186.ap-northeast-2.compute.amazonaws.com"
    Elasticsearch::Model.client = Elasticsearch::Client.new url: url
  Searchkick.client = Elasticsearch::Client.new(hosts: url, retry_on_failure: true, transport_options: {request: {timeout: 250}})

  