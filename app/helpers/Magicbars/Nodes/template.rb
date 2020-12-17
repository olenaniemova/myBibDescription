module Magicbars
  module Nodes
    class Template
      attr_reader :statements

      def initialize(statements)
        @statements = statements
      end
    end
  end
end
