module Magicbars
  class Parser
    def self.parse(tokens)
      # new(tokens).parse

      # Ahmed, T. and Meehan, N. 2012. Advanced reservoir management and engineering. 2nd ed.Amsterdam: Gulf Professional Publishing. - Harvard

      # Mook, D. (2004). Classic experiments in psychology. Westport, CT: Greenwood. - APA
      # Bragg, S. M. (2010). Wiley revenue recognition: Rules and scenarios (2nd ed.). Hoboken, NJ: Wiley.

      # Тимошик, Микола. Видавнича справа та редагування. Ін Юре, 2004. - MLA
      # Bragg, Steven. Wiley Revenue Recognition: Rules and Scenarios. 2nd ed. Hoboken, NJ: Wiley, 2010. Print.


      # "Kreg, E.G., 1974. Pro mistectvo teatru. Kyiv: Mystetstvo."
      # p tokens
      # arg = [[:AUTHOR, "Kreg, E.G."], [:COMA, ','], [:YEAR, "1974"], [:DOT, '.'],
      # [:TITLE, "Pro mistectvo teatru"],[:DOT, '.'], [:CITY, "Kyiv"], [:COLON, ':'],
      # [:PUBLISHER, "Mystetstvo"], [:DOT, "."]]
      # p arg
      # p "Harvard style"

      # Ahmed, T., 2012. Advanced reservoir management and engineering. Amsterdam: Gulf Professional Publishing. - Harvard
      #             p tokens
      # arg = [[:AUTHOR, "Ahmed, T."], [:COMA, ','], [:YEAR, "2012"], [:DOT, '.'],
      # [:TITLE, "Advanced reservoir management and engineering"],[:DOT, '.'], [:CITY, "Amsterdam"], [:COLON, ':'],
      # [:PUBLISHER, "Gulf Professional Publishing"], [:DOT, "."]]
      # p arg
      # p "Harvard style"


      # Mook, D. (2004). Classic experiments in psychology. Westport, CT: Greenwood. - APA
      # p tokens
      # arg = [[:AUTHOR, "Mook, D"], [:DOT, '.'], [:OPENING_BRACKET, '('], [:YEAR, "2004"], [:CLOSING_BRACKET, ')'], [:DOT, '.'],
      # [:TITLE, "Classic experiments in psychology"],[:DOT, '.'], [:CITY, "Westport, CT"], [:COLON, ':'],
      # [:PUBLISHER, "Greenwood"], [:DOT, "."]]
      # p arg
      # p "APA style"

      # Bragg, S. M. (2010). Wiley revenue recognition: Rules and scenarios. Hoboken, NJ: Wiley.
      # p tokens
      # arg = [[:AUTHOR, "Bragg, S. M"], [:DOT, '.'], [:OPENING_BRACKET, '('], [:YEAR, "2010"], [:CLOSING_BRACKET, ')'], [:DOT, '.'],
      # [:TITLE, "Wiley revenue recognition: Rules and scenarios"],[:DOT, '.'], [:CITY, "Hoboken, NJ"], [:COLON, ':'],
      # [:PUBLISHER, "Wiley"], [:DOT, "."]]
      # p arg
      # p "APA style"

      # Тимошик, Микола. Видавнича справа та редагування. Ін Юре, 2004. - MLA

            p tokens
      arg = [[:AUTHOR, "Тимошик, Микола"], [:DOT, '.'], [:TITLE, "Видавнича справа та редагування"],
      [:DOT, '.'], [:PUBLISHER, "Ін Юре"], [:YEAR, "2004"],  [:DOT, "."]]
      p arg
      p "MLA style"

            # Bragg, Steven. Wiley Revenue Recognition: Rules and Scenarios. Hoboken, NJ: Wiley, 2010.

      #       p tokens
      # arg = [[:AUTHOR, "Bragg, Steven"], [:DOT, '.'], [:TITLE, "Wiley Revenue Recognition: Rules and Scenarios"],
      # [:DOT, '.'], [:CITY, "Hoboken, NJ"], [:COLON, ':'], [:PUBLISHER, "Wiley"], [:YEAR, "210"],  [:DOT, "."]]
      # p arg
      # p "MLA style"
    end

    attr_reader :tokens

    def initialize(tokens)
      @tokens = tokens
    end

    # def parse
    #   Magicbars::Nodes::Template.new(parse_content)
    # end

    # def parse_content
    #   return unless tokens[0][0] == :CONTENT

    #   Magicbars::Nodes::Content.new(tokens[0][1])
    # end

    def parse
      # Magicbars::Nodes::Template.new(parse_statements)
      # str = ""
      # "Kreg, E.G., 1974. Pro mistectvo teatru. Kyiv: Mystetstvo."
      # binding.pry
      # p tokens
      arg = {AUTHOR: "Kreg, E.G.", COMA: ',', YEAR: "1974", DOT: '.', TITLE: "Pro mistectvo teatru"}
      p arg
      p "Hatvard style"


    end

    def parse_statements
      results = []

      while result = parse_statement
        results << result
      end

      results
    end
  end
end
