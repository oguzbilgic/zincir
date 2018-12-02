require 'sinatra'
require "sinatra/json"
require 'httparty'

require "./web.rb"
require "./block.rb"
require "./blockchain.rb"
require "./network.rb"

$blockchain = Blockchain.new
$network = Network.new $blockchain, "http://localhost:#{$port}", ARGV[0]

# Web Thread
Thread.new {
  Web.run!
  exit
}

# Download blocks from the seed node
$network.download_chain

$blockchain.on_solve do |block|
  $network.broadcast_block block
end

$blockchain.work!

# # trap('INT') do
#   dump_str = Marshal.dump $blockchain
#   File.write '.blockchain.dump', dump_str
#   puts 'yoyoy'
#   # exit
# # end
