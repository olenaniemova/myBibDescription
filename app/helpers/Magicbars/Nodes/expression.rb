module Magicbars
  module Nodes
    class Expression
      attr_reader :identifier, :arguments

      def initialize(identifier, arguments)
        @identifier = identifier
        @arguments = arguments
      end
    end
  end
end
