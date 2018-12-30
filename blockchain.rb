class Blockchain
  Manager = OpenStruct.new(instance: nil)

  def initialize
    @blocks = [Block.first]
    @relayed_blocks = []
    @callbacks = []
  end

  def Blockchain.instance
    Blockchain::Manager.instance = Blockchain.new if Blockchain::Manager.instance.nil?
    Blockchain::Manager.instance
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
    return if @relayed_blocks.empty?

    if @blocks.last.index >= @relayed_blocks.first.index
      while @blocks.last.index >= @relayed_blocks.first.index
        index = @relayed_blocks.first.index
        our_block = block_at index
        if our_block.timestamp > @relayed_blocks.first.timestamp
          # pick relayed block
          @blocks = @blocks[0..index]
          @blocks << @relayed_blocks.shift
          puts "Picking relayed #{@blocks.last}"
        else
          # pick our block
          @relayed_blocks.shift
          puts "Picking our block for index #{index}"
        end

        break if @relayed_blocks.empty?
      end

    elsif @blocks.last.index + 1 == @relayed_blocks.first.index
      #check prev hash
      puts "Adding relayed #{@relayed_blocks.first}"
      @blocks << @relayed_blocks.shift
    end

    return true
  end

  def work!
    loop do
      next if process_relayed

      next_block = Block.next self.last, "Transaction Data..."

      next if process_relayed

      @blocks << next_block

      puts "Solved #{next_block}"
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
