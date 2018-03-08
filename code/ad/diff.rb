class Dual
  attr_accessor :val, :diff

  def initialize(val, diff = 0)
    self.val = val
    self.diff = diff
  end

  def to_s
    "#{val} + #{diff}*E"
  end

  def +(other)
    Dual.new val: val + other.val, diff: diff + other.diff
  end

  def *(other)
    Dual.new val: val * other.val, diff: val * other.diff + diff * other.val
  end

  
end

module Kernel
  def Dual(val, diff = 0)
    case val
    when Dual
      val
    else
      Dual.new(val: val, diff: diff)
    end
  end
end
