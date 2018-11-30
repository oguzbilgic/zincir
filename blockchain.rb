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

    puts block
  end

  def work!
    loop do
      next_block = Block.next $blockchain.last, "Transaction Data..."

      @blocks << next_block

      puts next_block
    end
  end
end
