# TODO Don't depend on global variables $blockchain, $netwoek and $PORT
$port = 4000+rand(1000)

class Web < Sinatra::Base
  configure do
    set :port, $port
    set :quiet, true
    set :logging, false
  end

  post '/connect' do
    puts "Node connected: #{params['ip']}"
    $network.add_node params['ip']
  end

  post '/relay' do
    block = Block.from_json_str(request.body.read)
    $blockchain.add_relayed_block block
    puts "Received: #{block}"
  end

  get '/blocks' do
    json $blockchain.last.to_hash
  end

  get '/blocks/:index' do
    index = params['index'].to_i

    return status 404 if index > $blockchain.last.index

    json $blockchain.block_at(index).to_hash
  end
end
