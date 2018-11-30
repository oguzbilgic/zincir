require 'sinatra'
require "sinatra/json"
require "./block.rb"
require "./blockchain.rb"

$blockchain = Blockchain.new

class Web < Sinatra::Base
  configure do
    set :port, 4000+rand(1000)
    # set :quiet, true
    # set :logging, false
  end

  get '/blocks' do
    json $blockchain.last.to_hash
  end

  get '/blocks/:index' do
    index = params['index']
    json $blockchain.block_at(index.to_i).to_hash
  end
end

# Web Thread
Thread.new {
  Web.run!
  exit
}

## Main loop
if ARGV[0]
  seed_node = ARGV[0]
  puts "Seed node: #{seed_node}"
else
  puts "Starting as stand alone node"
end

require 'httparty'
require 'json'

def fetch_block index
end

if ARGV[0]
  loop do
    index = $blockchain.last.index.to_i + 1
    response = HTTParty.get("#{ARGV[0]}/blocks/#{index.to_s}")

    break if response.code != 200

    block_hash = JSON.parse(response.body)
    block = Block.new block_hash["index"].to_i, block_hash["timestamp"], block_hash["data"], block_hash["previous_hash"], block_hash["nonce"].to_i, block_hash["hash"]
    $blockchain << block
    puts block
  end

  puts 'Finished downloading the chain'
end

$blockchain.work!
