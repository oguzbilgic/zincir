class Blockchain
  def initialize
    @blocks = [Block.first]
    @relayed_blocks = []
    @callbacks = []
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

  def process_relayed
    if !@relayed_blocks.empty?
      if @blocks.last.index >= @relayed_blocks.first.index
        while @blocks.last.index >= @relayed_blocks.first.index
          index = @relayed_blocks.first.index
          our_block = block_at index
          if our_block.timestamp > @relayed_blocks.first.timestamp
            # pick relayed block
            @blocks = @blocks[0..index]
            @blocks << @relayed_blocks.shift
            puts "Picking relayed block for index #{index}"
          else
            # pick our block
            @relayed_blocks.shift
            puts "Picking our block for index #{index}"
          end

          break if @relayed_blocks.empty?
        end

      else @blocks.last.index + 1 == @relayed_blocks.first.index
        #check prev hash
        puts "Adding relayed block for index #{@relayed_blocks.first.index}"
        @blocks << @relayed_blocks.shift
      end

      return true
    end
  end

  def work!
    loop do
      next if process_relayed

      next_block = Block.next self.last, "Transaction Data..."

      next if process_relayed

      @blocks << next_block

      puts "Solved: #{next_block}"
      @callbacks.each { |callback| callback.call(next_block)  }
    end
  end

  def on_solve &block
    @callbacks << block
  end

  def add_relayed_block block
    @relayed_blocks << block
  end
end
