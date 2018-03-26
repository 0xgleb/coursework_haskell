# class that handles HTTP requests
class MainController < ApplicationController
  # /check
  def check
    # .nil? returns true if the object is nil
    # parse the expression from the request and return boolean
    # in JSON format that shows if the expression is valid or not
    render json: !parse(JSON.parse(request.body.read)).nil?
  end

  # /evaluate
  def evaluate
    # check if the expression is valid
    if (expr = parse(JSON.parse(request.body.read))).nil?
      # if it's invalid respond with an error
      render body: 'Invalid expression!', status: 400
    else
      # evaluate the expression and return the result in JSON
      render json: eval_expr(expr)
    end
  end

  # everything below is private
  private

  # class that represents a simple mathematical expression
  class Expr
    # getters and setters for a binary operator and two operands
    attr_accessor :operator, :operand1, :operand2

    # simple class constructor
    def initialize(operator, operand1, operand2)
      self.operator = operator
      self.operand1 = operand1
      self.operand2 = operand2
    end
  end

  # function for evaluating expressions
  def eval_expr(expr)
    # return nil if the given expression is nil
    nil if expr.nil?

    case expr
    when Expr # when the expression is an instance of Expr
      # evaluate the operands and apply the operator to the results
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
      # when the expression is not an instance of Expr it should be a number
      # return the number
      expr
    end
  end

  # function for parsing expressions
  def parse(str)
    exprs = []  # array of expressions used as a stack
    buffer = '' # buffer for parsing numbers

    # loop through each character
    str.each_char do |d|
      # we can apply operators only if there are at least two expressions in the stack
      if exprs.length >= 2
        # if the current character is an operator then take first two elements
        # from the stack, construct a new expression, and put it in the stack
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
          # if the buffer isn't empty then there is a number in it
          unless buffer.empty?
            begin # try
              x = Float(buffer) # convert to float
              exprs.unshift x   # put in the stack
              buffer = ''       # empty the buffer
            rescue(ArgumentError) # catch parsing exception
              # the expression is invalid, break the loop
              break
            end
          end
        else
          # put the character in the buffer
          buffer << d
        end
      else # less than two elements in the stack
        # only need to check if the character is ' '
        case d
        when ' '
          # the same behavior in case of a space
          unless buffer.empty?
            begin
              x = Float(buffer)
              exprs.unshift x
              buffer = ''
            rescue(ArgumentError)
              break
            end
          end
        else
          # put the character in the buffer
          buffer << d
        end
      end
    end

    # if the buffer is empty and the expressions stack has only one element
    # return the expression
    exprs.shift if exprs.length == 1 && buffer.empty?

    # expressions in reverse polish notation should have an operator at the end,
    # so if the buffer isn't empty then the expression is invalid.
  end
end
