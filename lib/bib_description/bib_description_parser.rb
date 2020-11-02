require 'parslet'

module BibDescription

  class BibDescriptionParser < Parslet::Parser
    # Single character rules
    rule(:lparen)     { str('(') >> space? }
    rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }
    rule(:dot)        { str('.') >> space? }
    rule(:semidot)    { str(':') >> space? }

    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    # Things
    rule(:integer)    { match('[0-9]').repeat(1).as(:int) >> space? }
    # rule(:word)       { match['\w'].repeat >> space? }
    rule(:letter)     { match['[:alnum:]'].repeat(1) }
    rule(:word)      { match['[:alnum:]'].repeat } # + cyrillic. Check also [[:word:]] and [[:alpha:]].

    rule(:identifier) { match['a-z'].repeat(1) }
    rule(:operator)   { match('[+]') >> space? }

    # Grammar parts
    rule(:sum)        {
      integer.as(:left) >> operator.as(:op) >> expression.as(:right) }
    rule(:arglist)    { expression >> (comma >> expression).repeat }
    rule(:funcall)    {
      identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }


    rule(:year) { match('[0-9]').repeat(4) >> space? }

    rule(:mla) { word.as(:city) >> semidot >> word.as(:publisher) >> comma >> year.as(:year) >> dot }

    rule(:sentence) { word >> ( space >> word ).repeat }
    rule(:full_title) { sentence.as(:title) >> (semidot >> sentence.as(:subtitle)) }

    rule(:author) { word.as(:last_name) >> comma >> letter.as(:first_name) >> dot  }
    rule(:authors) { author.as(:author) >> (comma >> author.as(:author)).repeat }


    rule(:apa) { authors.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title >> dot >> word.as(:city) >> semidot >> word.as(:publisher) >> dot }

    # rule(:apa?) { apa }


    # rule(:expression) { mla | funcall | sum | integer }
    rule(:expression) { apa }
    root :expression



    def self.parse(str = "Kyiv: Publisher1, 2020.")
      # str = "Київ: Видавництво1, 2020."
      # str = "Kyiv: Publisher1, 2020."
      str = "Lastname, L., Lasty2, N. (2020). Title: Subtitle text. Kyiv: Publisher1."
      # str = "Title Subtitle text: title2 texttex"
      # str = "Lastname, L., Lasty2, N. (2020)"
      p str
      puts ""

      mini = BibDescriptionParser.new

      parsered = mini.parse(str)
      # p parsered

      # binding.pry

      parsered
    rescue Parslet::ParseFailed => failure
      puts failure.parse_failure_cause.ascii_tree
    end

    def self.get_rule(str = "Kyiv: Publisher1, 2020.")
      b = BibDescription::BibDescriptionParser.new()

      return "APA" if b.is_apa?(str)
      return "MLA" if b.is_mla?(str)
    end

    def is_apa?(str)
      BibDescriptionParser.new().apa.parse(str).present?
    rescue Parslet::ParseFailed => failure
      false
    end

    def is_mla?(str)
      BibDescriptionParser.new().mla.parse(str).present?
    rescue Parslet::ParseFailed => failure
      false
    end

  end


end
ActiveRecord::Base.send :include, BibDescription
