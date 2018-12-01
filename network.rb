class Network
  def initialize blockchain, our_ip, node = nil
    @blockchain = blockchain
    @our_ip = our_ip
    @nodes = node ? [node] : []
  end

  def add_node node
    @nodes << node
  end

  def broadcast_block block
    @nodes.each do |node|
      begin
        HTTParty.post "#{node}/relay", body: block.to_hash.to_json
      rescue
        #remove node?
      end
    end
  end

  def download_chain
    return if @nodes.empty?

    puts "Seed node: #{@nodes.first}"

    # Connect to seed node
    HTTParty.post "#{@nodes.first}/connect", body: { ip: @our_ip }

    loop do
      index = @blockchain.last.index.to_i + 1
      response = HTTParty.get("#{@nodes.first}/blocks/#{index.to_s}")

      break if response.code != 200

      @blockchain << Block.from_json_str(response.body)
      # TODO use add_relayed_block instead
      puts "Downloaded #{@blockchain.last}"
    end

    puts "Finished downloading the chain"
  end
end
