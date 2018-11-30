require 'sinatra'
require "sinatra/json"
require 'httparty'
require "./block.rb"
require "./blockchain.rb"

$blockchain = Blockchain.new
$nodes = []
PORT = 4000+rand(1000)

class Web < Sinatra::Base
  configure do
    set :port, PORT
    set :quiet, true
    set :logging, false
  end

  post '/connect' do
    puts "Node connected: #{params['ip']}"
    $nodes << params['ip']
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

# Web Thread
Thread.new {
  Web.run!
  exit
}

# Download blocks from the seed node
if ARGV[0]
  $nodes << ARGV[0]
  puts "Seed node: #{ARGV[0]}"

  # Connect to seed node
  HTTParty.post "#{ARGV[0]}/connect", body: { ip: "http://localhost:#{PORT}" }

  loop do
    index = $blockchain.last.index.to_i + 1
    response = HTTParty.get("#{ARGV[0]}/blocks/#{index.to_s}")

    break if response.code != 200

    $blockchain << Block.from_json_str(response.body)
    # TODO use add_relayed_block instead
    puts "Downloaded #{$blockchain.last}"
  end

  puts "Finished downloading the chain"
end

$blockchain.on_solve do |block|
  $nodes.each do |node|
    begin
      HTTParty.post "#{node}/relay", body: block.to_hash.to_json
    rescue
      #remove node?
    end
  end
end

$blockchain.work!
