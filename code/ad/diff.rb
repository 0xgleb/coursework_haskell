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

  def **(other)
    Dual.new 
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

Math.singleton_class.prepend Module.new {
  def sin(x)
    case x
    when Dual
      Dual.new val: sin(x.val), diff: x.diff * cos(x.val)
    else super
    end
  end

  def cos(x)
    case x
    when Dual
      Dual.new val: cos(x.val), diff: -x.diff * sin(x.val)
    else super
    end
  end

  def exp(x)
    case x
    when Dual
      Dual.new val: exp(x.val), diff: x.diff * exp(x.val)
    else super
    end
  end
}
