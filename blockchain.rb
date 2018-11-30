class Blockchain
  def initialize
    @blocks = [Block.first]
  end

  def last
    @blocks.last
  end

  def << block
    @blocks << block
  end
end
