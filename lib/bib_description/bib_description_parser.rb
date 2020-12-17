require 'parslet'

module BibDescription

  class BibDescriptionParser < Parslet::Parser
    # Single character rules
    rule(:lparen)     { str('(') >> space? }
    rule(:rparen)     { str(')') >> space? }
    rule(:comma)      { str(',') >> space? }
    rule(:dot)        { str('.') >> space? }
    rule(:semidot)    { str(':') >> space? }
    rule(:dash)       { str('-') >> space? }
    rule(:ampersand)  { str('&') >> space? }
    rule(:dots)       { str('…') >> space? }
    rule(:quote)      { ( str('"') | str('”') ) >> space? }

    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:letter)     { match['[:alnum:]'].repeat(1) }
    rule(:word)      { match['[:alnum:]'].repeat } # + cyrillic. Check also [[:word:]] and [[:alpha:]].

    rule(:year) { match('[0-9]').repeat(4) >> space? }
    rule(:city) { sentence >> ( comma >> sentence ).maybe }
    rule(:sentence) { word >> ( space >> word ).repeat }

    rule(:edition_number) { lparen.maybe >> (sentence >> dot).as(:edition_number) >> rparen.maybe }

    rule(:in_part) { ( str('In') | str('У') ) >> space? }
    rule(:and_part) { ( str('and') | str('та') ) >> space? }
    rule(:edited_by) { ( str('edited by') | str('під редакцією') | str('Ed.') | str('За ред.') ) >> space? }
    rule(:edited_by_mla) { ( str('Ed') | str('За ред') ) >> space? }
    rule(:et_al_part) { ( str('et al') | str('та ін') ) >> space? }


    rule(:title_apa)      { sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe }
    rule(:title_with) { sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> (space.maybe >> edition_number).maybe   }
    rule(:full_title) { title_apa }




    # APA

    # book
    # Книга: 1-7 авторів
    # Прізвище1, Ініціали1, Прізвище2, Ініціали2, Прізвище3, Ініціали3, Прізвище4, Ініціали4, Прізвище5, Ініціали5, Прізвище6, Ініціали6, & Прізвище7, Ініціали7. (Рік). Назва книги: Підназва (номер видання). Місце видання: Видавництво.

    # Книга: 8 і більше авторів
    # Прізвище1, Ініціали1, Прізвище2, Ініціали2, Прізвище3, Ініціали3, Прізвище4, Ініціали4, Прізвище5, Ініціали5, Прізвище6, Ініціали6 … Прізвище останнього автора, Ініціали. (Рік). Назва книги: Підназва (номер видання). Місце видання: Видавництво.

    rule(:author_apa) { word.as(:last_name) >> comma >> letter.as(:first_name) >> dot >> (letter.as(:second_name) >> dot).maybe  }
    rule(:authors_apa) { author_apa.as(:author) >> (((comma >> ampersand.maybe) | dots.maybe) >> author_apa.as(:author)).repeat }
    rule(:apa_book) { authors_apa.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title >> dot >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot }

    # part_of_book
    # Прізвище автора глави, Ініціали. (Рік). Назва глави: Підназва. В Ініціали Прізвище редактора або укладача (відповідальність*), Назва книги: Підназва (номер видання). (cторінковий інтервал). Місце видання: Видавництво.

    rule(:editor) { word >> space >> letter.as(:first_name) >> dot >> word.as(:last_name) >> space >> lparen >> word >> dot >> rparen }
    rule(:pages) { lparen >> word >> dot >> (match('[0-9]').repeat >> ( dash >> match('[0-9]').repeat).maybe ).as(:pages) >> rparen }
    rule(:apa_part_of_book) { authors_apa.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title.as(:chapter_name) >> dot >> editor.as(:editors) >> comma >> full_title.as(:book_name) >> dot.maybe >> pages >> dot >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot }



    # article
    # Прізвище, Ініціали. (Рік). Назва статті: Підназва. Назва журналу, Номер журналу, Сторінковий інтервал.

    rule(:jornal_number_apa) { match('[0-9]').repeat >> lparen >> match('[0-9]').repeat >> rparen }
    rule(:jornal_pp_apa) { match('[0-9]').repeat >> dash >> match('[0-9]').repeat }
    rule(:apa_article) { authors_apa.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title >> dot >> sentence.as(:journal) >> comma >> jornal_number_apa.as(:journal_number) >> comma >> jornal_pp_apa.as(:pages) >> dot }

    # rule(:apa) { apa_book }
    rule(:apa) { apa_book | apa_part_of_book | apa_article }



    # MLA

    # book
    # Книга: 1-3 автора
    # Прізвище1, Ім’я1, Ім’я2 Прізвище2, та Ім’я3 Прізвище3. Назва книги: Підназва. Номер видання. Місце видання: Видавництво, Рік. Тип публікації.

    # Gordon, Virginia, Wesley Habley, and Thomas Grites. Academic Advising. San Francisco, CA: Jossey-Bass, 2008. Print.

    # Книга: 4 і більше авторів
    # Прізвище1, Ім’я1, та ін. Назва книги: Підназва. Номер видання. Місце видання: Видавництво, Рік. Тип публікації.

    # "Habyarimana, James, et al. Coethnicity. New York: Russell Sage Foundation, 2009. Print.",
    # "Прусова, Ганна, та ін. Математика. Київ: Освіта, 2004. Друк."

    rule(:first_author_mla) { word.as(:last_name) >> comma >> word.as(:first_name) }
    rule(:author_mla) { word.as(:first_name) >> space >> word.as(:last_name) }
    rule(:authors_mla) { first_author_mla.as(:author) >> ( comma >> et_al_part ).maybe >> ( comma >> and_part.maybe >> author_mla.as(:author)).repeat >> dot }

    rule(:full_title_mla) { sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot >> ( edition_number.as(:edition_number)).maybe }

    rule(:mla_book) { authors_mla.as(:authors) >> full_title_mla >> city.as(:city) >> semidot >> sentence.as(:publisher) >> comma >> year.as(:year) >> dot >> word.as(:publication_type) >> dot }

    # part of book
    # Прізвище автора частини, Ім’я. "Назва частини: Підназва." Назва книги: Підназва. Номер видання. Відомості про редактора. Місце видання: Видавництво, Рік. Сторінковий інтервал. Тип публікації.

    # Grosman, David. "Writing in the Dark." Burn This Book. Ed. Toni Morrison. New York: Harper, 2009. 22-32. Print.
    # Балашова, Єва. "Стратегічні дослідження." Пріоритети інвестиційного забезпечення. За ред. А. Сухорукова. Київ: Наукова думка, 2004. 5-9. Друк.

    rule(:full_title_mla_part_book) { (quote >> sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot >> quote).as(:chapter_name) >> (sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot).as(:book_name)  }
    rule(:mla_pages) { match('[0-9]').repeat >> ( dash >> match('[0-9]').repeat).maybe }
    rule(:mla_editor) { edited_by_mla >> dot >> ( word.as(:first_name) | ( letter.as(:first_name) >> dot ) ) >> space.maybe >> word.as(:last_name) >> dot }

    rule(:mla_part_of_book) { authors_mla.as(:authors) >> full_title_mla_part_book >> mla_editor.as(:editors) >> city.as(:city) >> semidot >> sentence.as(:publisher) >> comma >> year.as(:year) >> dot >> mla_pages.as(:pages) >> dot >> word.as(:publication_type) >> dot }


    # article
    # Прізвище, Ім’я. "Назва статті: Підназва." Назва журналу Номер журналу (Рік): Сторінковий інтервал. Тип публікації.

    # Benjamin, Cornelius. "The Ethics of Scholarship." Journal of Higher Education 319 (1960): 71-80. Print. # 31.9
    # Роїк, Максим. "Сучасний стан реєстрації представників роду Salix." Біоенергетика 1 (2014): 21-23. Друк.

    rule(:full_title_mla_article) { quote >> sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot >> quote }
    rule(:full_title_mla_journal) { sentence.as(:journal) >> (match('[0-9]').repeat).as(:journal_number) >> lparen >> year.as(:year) >> rparen >> semidot >> mla_pages.as(:pages) }

    rule(:mla_article) { authors_mla.as(:authors) >> full_title_mla_article >> full_title_mla_journal >> dot >> word.as(:publication_type) >> dot }


    # rule(:mla) { mla_article }
    # rule(:mla) { authors_mla }
    rule(:mla) { mla_book | mla_part_of_book | mla_article }



    # CHICAGO

    # book
    # Книга: 1 і більше авторів
    # Прізвище 1, Ім’я1, Ім’я2 Прізвище2, Ім’я3 Прізвище3, та Ім’я4 Прізвище4. Рік. Назва книги: Підназва. Місце видання: Видавництво.

    # Pollan, Michael. 2006. The Omnivore’s Dilemma: A Natural History of Four Meals. New York: Penguin.
    # Ward, Geoffrey, and Ken Burns. 2007. The War: An Intimate History, 1941–1945. New York: Knopf.
    # Тимошик, Микола. 2004. Видавнича справа та редагування. Київ: Ін Юре.
    # Ломницька, Ярослава, та Надія Чабан. 2009. Хімічні та фізико-хімічні методи аналізу в екологічних дослідженнях. Львів: Видавничий центр ЛНУ ім. Івана Франка.
    # Шульгін, Василь, Микола Слободяник, та Вадим Павленко. 2014. Хімія. Харків: Фоліо.

    rule(:chicago_book) { authors_mla.as(:authors) >> year.as(:year) >> dot >> full_title >> dot >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot }


    # part of book
    # Прізвище автора частини книги, Ім’я. Рік. Назва частини книги. В Назва книги, відомості про редактора, Сторінковий інтервал частини книги. Місце видання: Видавництво.

    # Kelly, John. 2010. Seeing Red. In Anthropology and Global Counterinsurgency, edited by John Kelly, Beatrice Jauregui, Sean Mitchell, and Jeremy Walton, 67-83. Chicago: University of Chicago Press.
    # Балашова, Єва. 2014. Стратегічні дослідження. У Пріоритети інвестиційного забезпечення, під редакцією Андрія Сухорукова, 5-29. Київ: Наукова думка.


    rule(:chicago_editor) { edited_by >> author_mla.as(:editor) >> ( ( comma >> and_part.maybe >> author_mla.as(:editor) ).repeat ).maybe  }

    rule(:chicago_part_of_book) { authors_mla.as(:authors) >> year.as(:year) >> dot >> full_title.as(:chapter_name) >> dot >> in_part >> full_title.as(:book_name) >> comma >> chicago_editor.as(:editors) >> comma >> mla_pages.as(:pages) >> dot >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot }


    # article
    # Стаття з журналу (друк)
    # Прізвище, Ім`я. Рік. “Назва статті: Підназва.” Назва журналу Номер журналу: Сторінковий інтервал всієї статті.

    # Weinstein, Joshua. 2009. “The Market in Plato’s Republic.” Classical Philology 104:439-458.
    # Роїк, Максим. 2014. “Сучасний стан реєстрації представників роду Salix.” Біоенергетика 1(5):21-23.

    rule(:jornal_number_chicago) { match('[0-9]').repeat >> ( lparen >> match('[0-9]').repeat >> rparen ).maybe }
    rule(:chicago_article) { authors_mla.as(:authors) >> year.as(:year) >> dot >> full_title_mla_article >> sentence.as(:journal) >> jornal_number_chicago.as(:journal_number) >> semidot >> jornal_pp_apa.as(:pages) >> dot }

    # rule(:chicago) { chicago_article }
    rule(:chicago) { chicago_book | chicago_part_of_book | chicago_article }



    rule(:expression) { apa | mla | chicago }
    root :expression



    def self.parse(str)
      BibDescriptionParser.new.parse(str)
    rescue Parslet::ParseFailed => failure
      puts failure.parse_failure_cause.ascii_tree
    end

    def self.get_rule(str)
      b = BibDescription::BibDescriptionParser.new()

      return { style: 'apa', result: true } if b.is_apa?(str)
      return { style: 'mla', result: true } if b.is_mla?(str)
      return { style: 'chicago', result: true } if b.is_chicago?(str)
      { style: b.approximate_style(b, str), result: false }
    end

    def approximate_style(b, str)
      pos = 2
      style = nil

      if b.apa_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.apa_book_error(str).parse_failure_cause.pos.bytepos
        style = 'apa'
      end

      if b.apa_part_of_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.apa_part_of_book_error(str).parse_failure_cause.pos.bytepos
        style = 'apa'
      end

      if b.apa_article_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.apa_article_error(str).parse_failure_cause.pos.bytepos
        style = 'apa'
      end

      if b.mla_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.mla_book_error(str).parse_failure_cause.pos.bytepos
        style = 'mla'
      end

      if b.mla_part_of_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.mla_part_of_book_error(str).parse_failure_cause.pos.bytepos
        style = 'mla'
      end

      if b.mla_article_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.mla_article_error(str).parse_failure_cause.pos.bytepos
        style = 'mla'
      end


      if b.chicago_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.chicago_book_error(str).parse_failure_cause.pos.bytepos
        style = 'chicago'
      end

      if b.chicago_part_of_book_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.chicago_part_of_book_error(str).parse_failure_cause.pos.bytepos
        style = 'chicago'
      end

      if b.chicago_article_error(str).parse_failure_cause.pos.bytepos > pos
        pos = b.chicago_article_error(str).parse_failure_cause.pos.bytepos
        style = 'chicago'
      end


      style
    end

    def get_char(error_str)
      error_str.slice(/\d+\./).delete('.').to_i
    end

    def is_apa?(str)
      BibDescriptionParser.new().apa.parse(str).present?
    rescue Parslet::ParseFailed => failure
      # binding.pry
      # p failure.to_s
      false
    end

    def apa_error(str)
      return "OK" if BibDescriptionParser.new().apa.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure.to_s
    end

    def apa_book_error(str)
      return "OK" if BibDescriptionParser.new().apa_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def apa_part_of_book_error(str)
      return "OK" if BibDescriptionParser.new().apa_part_of_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def apa_article_error(str)
      return "OK" if BibDescriptionParser.new().apa_article.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end



    def is_mla?(str)
      BibDescriptionParser.new().mla.parse(str).present?
    rescue Parslet::ParseFailed => failure
      # p failure.to_s
      false
    end

    def mla_error(str)
      return "OK" if BibDescriptionParser.new().mla.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure.to_s
    end

    def mla_book_error(str)
      return "OK" if BibDescriptionParser.new().mla_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def mla_part_of_book_error(str)
      return "OK" if BibDescriptionParser.new().mla_part_of_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def mla_article_error(str)
      return "OK" if BibDescriptionParser.new().mla_article.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end


    def is_chicago?(str)
      BibDescriptionParser.new().chicago.parse(str).present?
    rescue Parslet::ParseFailed => failure
      # p failure.to_s
      # binding.pry
      false
    end

    def chicago_error(str)
      return "OK" if BibDescriptionParser.new().chicago.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure.to_s
    end

    def chicago_book_error(str)
      return "OK" if BibDescriptionParser.new().chicago_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def chicago_part_of_book_error(str)
      return "OK" if BibDescriptionParser.new().chicago_part_of_book.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end

    def chicago_article_error(str)
      return "OK" if BibDescriptionParser.new().chicago_article.parse(str).present?
    rescue Parslet::ParseFailed => failure
      failure
    end



    def self.test
      b = BibDescription::BibDescriptionParser.new()

      puts "APA"
      p "APA book:"
      [
        # 1-7
        # "Bragg, S. M. (2010). Wiley revenue recognition: Rules and scenarios (2nd ed.). Hoboken, NJ: Wiley.",
        "Bragg, S. M. (2010). Wiley revenue recognition: Rules and scenarios. Hoboken, NJ: Wiley.",
        "Тимошик, М. В. (2004). Видавнича справа та редагування. Київ: Ін Юре.",
        "Hubbard, R. G., Koehn, M. F., Omstein, S. I., Audenrode, M. V., & Royer, J. (2010). The mutual fund industry: Competition and investor welfare. New York, NY: Columbia University Press.",
        "Шульгін, В., Слободяник, М., & Павленко, В. (2014). Хімія. Харків: Фоліо.",
        # 8 and more
        "Zinn, H., Konopacki, M., Buhle, P., Watkins, J. E., Mills, S., Mullins, J. W. … Komisar, R. (2008). A peoples history of American empire: A graphic adaptation. New York, NY: Metropolitan Books.",
        "Прусова, В. Г., Прихач, О. С., Довгань, К. Л., Остапенко, Г. Г., Бойко, С. О., Поліщук, О. О. … Бондар, Г. Р. (2004). Математика. Київ: Освіта."
      ].each do |item|
        puts "#{b.is_apa?(item)} => #{item}"
        puts BibDescriptionParser.new().apa.parse(item)
      end
      puts

      p "APA part of book:"
      [
        "Grosman, D. (2009). Writing in the dark. In T. Morrison (Ed.), Burn this book (pp. 22-32). New York, NY: HarperCollins Publishers.",
        "Farrell, S. E. (2009). Art. In D. Simmons (Ed.), New critical essays on Kurt Vonnegut (p. 91). New York, NY: Palgrave Macmillan.",
        # "Балашова, Є. (2014). Стратегічні дослідження. В А. Сухоруков (Ред.), Пріоритети інвестиційного забезпечення (2ге вид.). (с. 5-9). Київ: Наукова думка."
        "Балашова, Є. (2014). Стратегічні дослідження. В А. Сухоруков (Ред.), Пріоритети інвестиційного забезпечення. (с. 5-9). Київ: Наукова думка."
      ].each do |item|
        puts "#{b.is_apa?(item)} => #{item}"
        puts BibDescriptionParser.new().apa.parse(item)
      end
      puts

      p "APA article:"
      [
        "Benjamin, A. C. (1960). The ethics of scholarship: A discussion of problems that arise in its application. Journal of Higher Education, 31(9), 471-480.",
        "Роїк, М. (2014). Сучасний стан реєстрації представників роду Salix. Біоенергетика, 1(5), 21-23."
      ].each do |item|
        puts "#{b.is_apa?(item)} => #{item}"
        puts BibDescriptionParser.new().apa.parse(item)
      end
      puts
      puts


      puts "MLA"
      p "MLA book:"
      [
        # 1-3
        "Bragg, Steven. Wiley Revenue Recognition: Rules and Scenarios. 2nd ed. Hoboken, NJ: Wiley, 2010. Print.",
        "Тимошик, Микола. Видавнича справа та редагування. Київ: Ін Юре, 2004. Друк.",
        # "Gordon, Virginia, Wesley Habley, Thomas Grites. Academic Advising. San Francisco, CA: JosseyBass, 2008. Print.", # and
        # "Шульгін, Василь, Микола Слободяник, Віктор Павленко. Хімія. Харків: Фоліо, 2004. Друк.",

        # # # 4 and more
        # "Habyarimana, James. Coethnicity. New York: Russell Sage Foundation, 2009. Print.",
        # "Прусова, Ганна. Математика. Київ: Освіта, 2004. Друк."

        "Gordon, Virginia, Wesley Habley, and Thomas Grites. Academic Advising. San Francisco, CA: Jossey Bass, 2008. Print.",
        "Шульгін, Василь, Микола Слободяник, та Віктор Павленко. Хімія. Харків: Фоліо, 2004. Друк.",

        "Habyarimana, James, et al. Coethnicity. New York: Russell Sage Foundation, 2009. Print.",
        "Прусова, Ганна, та ін. Математика. Київ: Освіта, 2004. Друк."

      ].each do |item|
        puts "#{b.is_mla?(item)} => #{item}"
        puts BibDescriptionParser.new().mla.parse(item)
      end
      puts

      p "MLA part of book:"
      [
        "Grosman, David. \"Writing in the Dark.\" Burn This Book. Ed. Toni Morrison. New York: Harper, 2009. 22-32. Print.",
        "Балашова, Єва. \"Стратегічні дослідження.\" Пріоритети інвестиційного забезпечення. За ред. Андрія Сухорукова. Київ: Наукова думка, 2004. 5-9. Друк." # A.
      ].each do |item|
        puts "#{b.is_mla?(item)} => #{item}"
        puts BibDescriptionParser.new().mla.parse(item)
      end
      puts

      p "MLA article:"
      [
        "Benjamin, Cornelius. \"The Ethics of Scholarship.\" Journal of Higher Education 31 (1960): 71-80. Print.", # 31.9
        "Роїк, Максим. \"Сучасний стан реєстрації представників роду Salix.\" Біоенергетика 1 (2014): 21-23. Друк."
      ].each do |item|
        puts "#{b.is_mla?(item)} => #{item}"
        puts BibDescriptionParser.new().mla.parse(item)
      end
      puts
      puts


      puts "CHICAGO"
      p "CHICAGO book:"
      [
        # "Pollan, Michael. 2006. The Omnivores Dilemma: A Natural History of Four Meals. New York: Penguin.",
        # "Ward, Geoffrey, Ken Burns. 2007. The War: An Intimate History. New York: Knopf.",
        # "Тимошик, Микола. 2004. Видавнича справа та редагування. Київ: Ін Юре.",
        # "Ломницька, Ярослава, Надія Чабан. 2009. Хімічні та фізико хімічні методи аналізу в екологічних дослідженнях. Львів: Видавничий центр ЛНУ ім Івана Франка.",
        # "Шульгін, Василь, Микола Слободяник, Вадим Павленко. 2014. Хімія. Харків: Фоліо."

        "Pollan, Michael. 2006. The Omnivores Dilemma: A Natural History of Four Meals. New York: Penguin.",
        "Ward, Geoffrey, and Ken Burns. 2007. The War: An Intimate History. New York: Knopf.",
        "Тимошик, Микола. 2004. Видавнича справа та редагування. Київ: Ін Юре.",
        "Ломницька, Ярослава, та Надія Чабан. 2009. Хімічні та фізико хімічні методи аналізу в екологічних дослідженнях. Львів: Видавничий центр ЛНУ ім Івана Франка.",
        "Шульгін, Василь, Микола Слободяник, та Вадим Павленко. 2014. Хімія. Харків: Фоліо."

      ].each do |item|
        puts "#{b.is_chicago?(item)} => #{item}"
        puts BibDescriptionParser.new().chicago.parse(item)
      end
      puts

      p "CHICAGO part of book:"
      [
        "Kelly, John. 2010. Seeing Red. In Anthropology and Global Counterinsurgency, edited by John Kelly, Beatrice Jauregui, Sean Mitchell, and Jeremy Walton, 67-83. Chicago: University of Chicago Press.",
        "Балашова, Єва. 2014. Стратегічні дослідження. У Пріоритети інвестиційного забезпечення, під редакцією Андрія Сухорукова, 5-29. Київ: Наукова думка."
      ].each do |item|
        puts "#{b.is_chicago?(item)} => #{item}"
        puts BibDescriptionParser.new().chicago.parse(item)
      end
      puts

      p "CHICAGO article:"
      [
        "Weinstein, Joshua. 2009. \"The Market in Platos Republic.\" Classical Philology 104:439-458.",
        "Роїк, Максим. 2014. \"Сучасний стан реєстрації представників роду Salix.\" Біоенергетика 1(5):21-23."
      ].each do |item|
        puts "#{b.is_chicago?(item)} => #{item}"
        puts BibDescriptionParser.new().chicago.parse(item)
      end
      puts
      puts


    end
  end

end
ActiveRecord::Base.send :include, BibDescription

      # puts "HARVARD GB"
      # p "HARVARD GB book:"
      # [
      #   "Ahmed, T. and Meehan, N. 2012. Advanced reservoir management and engineering. 2nd ed. Amsterdam: Gulf Professional Publishing.",
      #   "Григоренко, П., Томак, М. та Тисячна, Н. 2013. Приховування історичної правди. 2ге вид. Київ: Українська пресгрупа."
      # ].each { |item| p "#{b.is_harvard?(item)} => #{item}" }
      # puts

      # p "HARVARD GB part of book:"
      # [
      #   "Kelly, John. 2010. Seeing Red. In Anthropology and Global Counterinsurgency, edited by John Kelly, Beatrice Jauregui, Sean Mitchell, and Jeremy Walton, 67-83. Chicago: University of Chicago Press.",
      #   "Балашова, Єва. 2014. Стратегічні дослідження. У Пріоритети інвестиційного забезпечення, під редакцією Андрія Сухорукова, 5-29. Київ: Наукова думка."
      # ].each { |item| p "#{b.is_harvard?(item)} => #{item}" }
      # puts

      # p "HARVARD GB article:"
      # [
      #   "Weinstein, Joshua. 2009. \"The Market in Platos Republic.\" Classical Philology 104:439-458.",
      #   "Роїк, Максим. 2014. \"Сучасний стан реєстрації представників роду Salix.\" Біоенергетика 1(5):21-23."
      # ].each { |item| p "#{b.is_harvard?(item)} => #{item}" }
      # puts
      # puts


    # DSTU
    # book
    # Книги: Один автор
    # Бичківський О. О. Міжнародне приватне право : конспект лекцій. Запоріжжя : ЗНУ, 2015. 82 с.
    # Бондаренко В. Г. Немеркнуча слава новітніх запорожців: історія Українського Вільного козацтва на Запоріжжі (1917-1920 рр.). Запоріжжя, 2017. 113 с.
    # Бондаренко В. Г. Український вільнокозацький рух в Україні та на еміграції (1919-1993 рр.) : монографія. Запоріжжя : ЗНУ, 2016. 600 с.
    # Вагіна О. М. Політична етика : навч.-метод. посіб. Запоріжжя : ЗНУ, 2017. 102 с.
    # Верлос Н. В. Конституційне право зарубіжних країн : курс лекцій. Запоріжжя : ЗНУ, 2017. 145 с.
    # Горбунова А. В. Управління економічною захищеністю підприємства: теорія і методологія : монографія. Запоріжжя : ЗНУ, 2017. 240 с.
    # Гурська Л. І. Релігієзнавство : навч. посіб. 2-ге вид., перероб. та доп. Київ : ЦУЛ, 2016. 172 с.
    # Дробот О. В. Професійна свідомість керівника : навч. посіб. Київ : Талком, 2016. 340 с.


    # Два автори
    # Аванесова Н. Е., Марченко О. В. Стратегічне управління підприємством та сучасним містом: теоретико-методичні засади : монографія. Харків : Щедра садиба плюс, 2015. 196 с.
    # Батракова Т. І., Калюжна Ю. В. Банківські операції : навч. посіб. Запоріжжя : ЗНУ, 2017. 130 с.
    # Білобровко Т. І., Кожуховська Л. П. Філософія науки й управління освітою : навч.-метод. посіб. Переяслав-Хмельницький, 2015. 166 с.
    # Богма О. С., Кисильова І. Ю. Фінанси : конспект лекцій. Запоріжжя : ЗНУ, 2016. 102 с.
    # Горошкова Л. А., Волков В. П. Виробничий менеджмент : навч. посіб. Запоріжжя : ЗНУ, 2016. 131 с.
    # Гура О. І., Гура Т. Є. Психологія управління соціальною організацією : навч. посіб. 2-ге вид., доп. Херсон : ОЛДІ-ПЛЮС, 2015. 212 с.

    # Три автори
    # Аніловська Г. Я., Марушко Н. С., Стоколоса Т. М. Інформаційні системи і технології у фінансах : навч. посіб. Львів : Магнолія 2006, 2015. 312 с.
    # Городовенко В. В., Макаренков О. Л., Сантос М. М. О. Судові та правоохоронні органи України : навч. посіб. Запоріжжя : ЗНУ, 2016. 206 с.
    # Кузнєцов М. А., Фоменко К. І., Кузнецов О. І. Психічні стани студентів у процесі навчально-пізнавальної діяльності : монографія. Харків : ХНПУ, 2015. 338 с.
    # Якобчук В. П., Богоявленська Ю. В., Тищенко С. В. Історія економіки та економічної думки : навч. посіб. Київ : ЦУЛ, 2015. 476 с.


    # Чотири і більше авторів
    # Науково-практичний коментар Кримінального кодексу України : станом на 10 жовт. 2016 р. / К. І. Бєліков та ін. ; за заг. ред. О. М. Литвинова. Київ : ЦУЛ, 2016. 528 с.
    # Бікулов Д. Т, Чкан А. С., Олійник О. М., Маркова С. В. Менеджмент : навч. посіб. Запоріжжя : ЗНУ, 2017. 360 с.
    # Операційне числення : навч. посіб. / С. М. Гребенюк та ін. Запоріжжя : ЗНУ, 2015. 88 с.
    # Основи охорони праці : підручник / О. І. Запорожець та ін. 2-ге вид. Київ : ЦУЛ, 2016. 264 с.
    # Клименко М. І., Панасенко Є. В., Стреляєв Ю. М., Ткаченко І. Г. Варіаційне числення та методи оптимізації : навч. посіб. Запоріжжя : ЗНУ, 2015. 84 с.


    # part of book
    # ЧАСТИНА ВИДАННЯ: КНИГИ
    # Баймуратов М. А. Имплементация норм международного права и роль Конституционного Суда Украины в толковании международных договоров / М. А. Баймуратов. Михайло Баймуратов: право як буття вченого : зб. наук. пр. до 55-річчя проф. М. О. Баймуратова / упоряд. та відп. ред. Ю. О. Волошин. К., 2009. С. 477–493.
    # Гетьман А. П. Екологічна політика держави: конституційно-правовий аспект. Тридцать лет с экологическим правом : избранные труды. Харьков, 2013. С. 205–212.
    # Коломоєць Т. О. Адміністративна деліктологія та адміністративна деліктність. Адміністративне право України : підручник / за заг. ред. Т. О. Коломоєць. Київ, 2009. С. 195–197.
    # Алексєєв В. М. Правовий статус людини та його реалізація у взаємовідносинах держави та суспільства в державному управлінні в Україні. Теоретичні засади взаємовідносин держави та суспільства в управлінні : монографія. Чернівці, 2012. С. 151–169.



    # article
    # ЧАСТИНА ВИДАННЯ: ПЕРІОДИЧНОГО ВИДАННЯ (ЖУРНАЛУ, ГАЗЕТИ)
    # Кулініч О. О. Право на освіту в системі конституційних прав людини і громадянина та його гарантії. Часопис Київського університету права. 2007. № 4. С. 88–92.
    # Коломоєць Т., Колпаков В. Сучасна парадигма адміністративного права: ґенеза і поняття. Право України. 2017. № 5. С. 71–79.
    # Коваль Л. Плюси і мінуси дистанційної роботи. Урядовий курєр. 2017. 1 листоп. (№ 205). С. 5.
    # Біленчук П., Обіход Т. Небезпеки ядерної злочинності: аналіз вітчизняного і міжнародного законодавства. Юридичний вісник України. 2017. 20-26 жовт. (№ 42). С. 14–15.
    # Bletskan D. I., Glukhov K. E., Frolova V. V. Electronic structure of 2H-SnSe2: ab initio modeling and comparison with experiment. Semiconductor Physics Quantum Electronics & Optoelectronics. 2016. Vol. 19, No 1. P. 98–108.



# HARVARD GB
    # book
    # Прізвище1, Ініціали1, Прізвище2, Ініціали2, Прізвище3, Ініціали3, Прізвище4, Ініціали4 та Прізвище5, Ініціали5. Рік. Назва книги. Номер видання*. Місце видання: Видавництво. * крім першого

    # Ahmed, T. and Meehan, N. 2012. Advanced reservoir management and engineering. 2nd ed. Amsterdam: Gulf Professional Publishing.
    # Григоренко, П., Томак, М. та Тисячна, Н. 2013. Приховування історичної правди. 2-ге вид. Київ: Українська прес-група.

    # rule(:author_harvard) { word.as(:last_name) >> comma >> letter.as(:first_name) >> ( dot >> letter.as(:second_name)).maybe  } # author_apa
    # rule(:authors_harvard) { author_harvard.as(:author) >> ( ( comma | ( and_part ) ) >> author_harvard.as(:author) ).repeat }

    # rule(:full_title_mla) { sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot >> ( edition_number.as(:edition_number)).maybe }

    # rule(:harvard_book) { authors_harvard.as(:authors) >> year.as(:year) >> dot >> full_title_mla >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot } # рік розпізнає як друге імя автора


    # part of book
    # Розділ книги за редакцією
    # Прізвище автора розділу, Ініціали, Рік публікації розділу. Назва розділу. В Ініціали Прізвище Редактора, ред. Рік публікації книги. Назва книги. Місце видання: Видавництво. Номер розділу або сторінковий інтервал.

    # Smith, J., 1975. A source of information. In: W. Jones, ed. 2000. One hundred and one ways to find information about health. Oxford: Oxford University Press. Ch.2.
    # Лосик, Г.В., 2001. Психологическая концепция моторной теории восприятия речи. В: Т.Н. Ушакова и Н.В. Уфимцева, ред. Детская речь: психолингвистические исследования. Москва: Per Se. с.9-22.


    # article
    # Стаття з журналу (друк)
    # Прізвище, Ініціали, Рік. Назва статті. Назва журналу, Номер тому (Номер випуску/частини), сторінковий інтервал.

    # Perry, C., 2001. What health care assistants know about clean hands. Nursing Times, 97(22), pp.63-64.
    # Пилипчук, В.П., Данніков, О.В. та Ямчинська, А.С., 2009. Впровадження інноваційних продуктів та розвиток ринку FMCG. Економічний вісник НТУУ «КПІ», 6, с.294-301.


    # rule(:harvard) { authors_harvard }
    # rule(:harvard) { harvard_book }
