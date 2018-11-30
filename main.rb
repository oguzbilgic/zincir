require 'sinatra'
require "sinatra/json"
require "./block.rb"
require "./blockchain.rb"

$blockchain = Blockchain.new

class Web < Sinatra::Base
  # configure do
  #   set :port, 80
  #   set :quiet, true
  #   set :logging, false
  # end

  get '/blocks' do
    json $blockchain.last.to_hash
  end

  get '/blocks/:index' do
    index = params['index']
    json $blockchain[index.to_i].to_hash
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

if !seed_node
  loop do
    next_block = Block.next $blockchain.last, "Transaction Data..."

    puts next_block.hash
    $blockchain << next_block
  end
end
