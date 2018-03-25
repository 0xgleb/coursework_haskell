class MainController < ApplicationController
  def check
    render json: !parse(JSON.parse(request.body.read)).nil?
  end

  def evaluate
    if (expr = parse(JSON.parse(request.body.read))).nil?
      render body: 'Invalid expression!', status: 400
    else
      render json: eval_expr(expr)
    end
  end

  private

  class Expr
    attr_accessor :operator, :operand1, :operand2

    def initialize(operator, operand1, operand2)
      self.operator = operator
      self.operand1 = operand1
      self.operand2 = operand2
    end

    def evaluate
      case operator
      when '+'
        operand1 + operand2
      when '-'
        operand1 + operand2
      when '*'
        operand1 * operand2
      when '/'
        operand1 / operand2
      end
    end
  end

  def eval_expr(expr)
    nil if expr.nil?

    case expr
    when Expr
      case expr.operator
      when '+'
        eval_expr(expr.operand1) + eval_expr(expr.operand2)
      when '-'
        eval_expr(expr.operand1) - eval_expr(expr.operand2)
      when '*'
        eval_expr(expr.operand1) * eval_expr(expr.operand2)
      when '/'
        eval_expr(expr.operand1) / eval_expr(expr.operand2)
      end
    else
      expr
    end
  end

  def parse(str)
    exprs = []
    accum_str = ''

    str.each_char do |d|
      if exprs.length >= 2
        case d
        when '+'
          exprs.unshift Expr.new '+', exprs.shift, exprs.shift
        when '-'
          exprs.unshift Expr.new '-', exprs.shift, exprs.shift
        when '*'
          exprs.unshift Expr.new '*', exprs.shift, exprs.shift
        when '/'
          exprs.unshift Expr.new '/', exprs.shift, exprs.shift
        when ' '
          unless accum_str.empty?
            begin
              x = Float(accum_str)
              exprs.unshift x
              accum_str = ''
            rescue
              break
            end
          end
        else
          accum_str << d
        end
      else
        case d
        when ' '
          unless accum_str.empty?
            begin
              x = Float(accum_str)
              exprs.unshift x
              accum_str = ''
            rescue
              break
            end
          end
        else
          accum_str << d
        end
      end
    end

    exprs.shift if exprs.length == 1 && accum_str.empty?
  end
end
