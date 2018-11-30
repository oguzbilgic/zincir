require 'sinatra'
require "sinatra/json"
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
    ip = params['ip']
    puts "Node: #{ip} is connected"
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
    if index > $blockchain.last.index
      status 404
      return
    end
    json $blockchain.block_at(index).to_hash
  end
end

# Web Thread
Thread.new {
  Web.run!
  exit
}

require 'httparty'

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
  end

  puts 'Finished downloading the chain'
end

$blockchain.on_solve do |block|
  json_str = block.to_hash.to_json
  $nodes.each do |node|
    begin
      HTTParty.post "#{node}/relay", body: json_str
    rescue
      #remove node?
    end
  end
end

$blockchain.work!
