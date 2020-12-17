require 'strscan'

module Magicbars
  class Lexer
    def self.tokenize(code)
      new.tokenize(code)
    end

    def tokenize(code)
      scanner = StringScanner.new(code)
      tokens = []

until scanner.eos?
if state == :default
  if scanner.scan(/{{#/)
    tokens << [:OPEN_BLOCK]
    push_state :expression
  elsif scanner.scan(/{{\//)
    tokens << [:OPEN_END_BLOCK]
    push_state :expression
  elsif scanner.scan(/{{else/)
    tokens << [:OPEN_INVERSE]
    push_state :expression
  elsif scanner.scan(/{{/)
    tokens << [:OPEN_EXPRESSION]
    push_state :expression
  elsif scanner.scan_until(/.*?(?={{)/m)
    tokens << [:CONTENT, scanner.matched]
  else
    tokens << [:CONTENT, scanner.rest]
    scanner.terminate
  end
elsif state == :expression
  if scanner.scan(/\s+/)
    # Ignore whitespace
  elsif scanner.scan(/}}/)
    tokens << [:CLOSE]
    pop_state
  elsif scanner.scan(/[\w\-]+/)
    tokens << [:IDENTIFIER, scanner.matched]
  else
    scanner.terminate
  end
end
end

      tokens
    end

def stack
  @stack ||= []
end

def state
  stack.last || :default
end

def push_state(state)
  stack.push(state)
end

def pop_state
  stack.pop
end


  end
end
