require 'json'
require "digest"

class Block
  attr_reader :index, :timestamp, :data, :previous_hash, :nonce, :hash

  def initialize index, timestamp, data, previous_hash, nonce = nil, hash = nil
    @index = index
    @timestamp = timestamp
    @data = data
    @previous_hash = previous_hash
    unless nonce && hash
      @nonce, @hash = compute_hash_with_proof_of_work
    else
      @nonce = nonce
      @hash = hash
      verify!
    end
  end

  def self.first
    Block.new 0, 0, "Genesis", "0"
  end

  def self.next previous, data
    Block.new previous.index + 1, Time.now.to_i, data, previous.hash
  end

  def self.from_json_str str
    block_hash = JSON.parse(str)

    Block.new block_hash["index"].to_i, block_hash["timestamp"], block_hash["data"], block_hash["previous_hash"], block_hash["nonce"].to_i, block_hash["hash"]
  end

  def to_hash
    { index: index, timestamp: timestamp, data: data, previous_hash: previous_hash, nonce: nonce, hash: hash }
  end

  def to_s
    "#{@hash} #{@index}"
  end

  def marshal_dump
    [ index, timestamp, data, previous_hash, nonce, hash ]
  end

  def verify!
    calculated_hash = calc_hash_with_nonce @nonce

    raise 'invalid' if calculated_hash != @hash
  end

  def compute_hash_with_proof_of_work difficulty="00000"
    nonce = 0
    loop do
      hash = calc_hash_with_nonce nonce
      if hash.start_with? difficulty
        return [nonce,hash]
      else
        nonce += 1
      end
    end
  end

  def calc_hash_with_nonce nonce = 0
    sha = Digest::SHA256.new
    sha.update nonce.to_s + @index.to_s + @timestamp.to_s + @data + @previous_hash
    sha.hexdigest
  end
end
