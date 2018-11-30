require 'sinatra'
require "sinatra/json"
require "./block.rb"

b0 = Block.first
puts b0.hash
puts b0.nonce
blockchain = [b0]

# loop do
#   next_block = Block.next blockchain.last, "Transaction Data..."
#
#   puts next_block.hash
#   blockchain << next_block
# end

get '/tip' do
  json blockchain.last.to_hash
end
