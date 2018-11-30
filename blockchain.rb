class Blockchain
  def initialize
    @blocks = [Block.first]
  end

  def last
    @blocks.last
  end

  def block_at index
    @blocks[index]
  end

  def << block
    @blocks << block
  end

  def work!
    loop do
      next_block = Block.next $blockchain.last, "Transaction Data..."

      puts next_block
      @blocks << next_block
    end
  end
end
