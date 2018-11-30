require "digest"

class Block
  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :nonce
  attr_reader :hash

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
    Block.new previous.index + 1, data, previous.hash
  end

  def to_hash
    { index: index, timestamp: timestamp, data: data, previous_hash: previous_hash, nonce: nonce, hash: hash }
  end

  def verify!
    calculated_hash = calc_hash_with_nonce @nonce

    raise 'invalid' if calculated_hash != @hash
  end

  def compute_hash_with_proof_of_work difficulty="000000"
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
