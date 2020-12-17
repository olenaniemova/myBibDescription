module Magicbars
  module Nodes
    class Identifier
      attr_reader :value

      def initialize(value)
        @value = value.to_sym
      end
    end
  end
end
