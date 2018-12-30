require 'sinatra'
require "sinatra/json"
require 'httparty'

require "./web.rb"
require "./block.rb"
require "./blockchain.rb"
require "./network.rb"

blockchain = Blockchain.instance
network = Network.instance "http://localhost:#{Web::Port}", ARGV[0]

# Web Thread
Thread.new {
  Web.run!
  exit
}

# Download blocks from the seed node
network.download_chain

blockchain.on_solve do |block|
  network.broadcast_block block
end

blockchain.work!
