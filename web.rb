class Web < Sinatra::Base
  Port = ENV['PORT'] ? ENV['PORT'] : 4000+rand(1000)

  configure do
    set :port, Web::Port
    set :quiet, true
    set :logging, false
  end

  post '/connect' do
    puts "Node connected: #{params['ip']}"
    Network.instance.add_node params['ip']
  end

  post '/relay' do
    block = Block.from_json_str(request.body.read)
    Blockchain.instance.add_relayed_block block
    status 200
  end

  get '/blocks' do
    json Blockchain.instance.last.to_hash
  end

  get '/blocks/:index' do
    index = params['index'].to_i

    return status 404 if index > Blockchain.instance.last.index

    json Blockchain.instance.block_at(index).to_hash
  end
end
