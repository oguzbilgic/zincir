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

require 'httparty'

# Download blocks from the seed node
if ARGV[0]
  puts "Seed node: #{seed_node}"

  loop do
    index = $blockchain.last.index.to_i + 1
    response = HTTParty.get("#{ARGV[0]}/blocks/#{index.to_s}")

    break if response.code != 200

    $blockchain << Block.from_json_str response.body
    puts block
  end

  puts 'Finished downloading the chain'
end

$blockchain.work!
