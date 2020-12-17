class ChangeStylesController < ApplicationController

  TRANSLATE = {
    'book' => 'книга',
    'part_of_book' => 'частина книги',
    'article' => 'стаття в журналі',
    'authors' => 'автори',
    'author' => 'автор',
    'last_name' => 'прізвище',
    'first_name' => "і'мя",
    'year' => 'рік',
    'title' => 'заголовок',
    'subtitle' => 'підназва',
    'city' => 'місто',
    'publisher' => 'видавництво',
    'edition_number' => 'номер видання',
    'publication_type' => 'тип публікації',
    'apa' => "APA",
    'mla' => 'MLA',
    'Chicago' => 'chicago',
    'dstu' => 'ДСТУ 8302:2015',
    'author' => 'автор',
    'author1' => 'автор 1',
    'author2' => 'автор 2',
    'author3' => 'автор 3',
    'author4' => 'автор 4',
    'author5' => 'автор 5',
    'author6' => 'автор 6',
    'author7' => 'автор 7',
    'author8' => 'автор 8',
    'author9' => 'автор 9',
    'author10' => 'автор 10',
    'journal' => 'журнал',
    'journal_number' => 'номер журналу',
    'pages'=> 'сторінки',
    'chapter_name_title'=>'назва глави',
    'chapter_name_subtitle'=>'підназва глави',
    'editor'=>'редактор',
    'editor1'=>'редактор 1',
    'editor2'=>'редактор 2',
    'editor3'=>'редактор 3',
    'editor4'=>'редактор 4',
    'editor5'=>'редактор 5',
    'book_name_title'=>'назва книги',
    'book_name_subtitle'=>'підназва книги'

  }

  def index
    render :step_1
  end

  def step_1
    p params
    # Parameters: {"description"=>{"style"=>"apa", "source"=>"book", "text"=>"dfgdfgdfg"}, "commit"=>"Визначити"}

    @description = params[:description]
    @items = BibDescription::BibDescriptionParser.parse(@description[:text])
    p @items
    proccess_authors
    proccess_editors if @items[:editors]
    proccess_chapter if @items[:chapter_name]

    # binding.pry
    # {:authors=>{:author=>{:last_name=>"Lastname"@0, :first_name=>"L"@10}}, :year=>"2020"@14, :title=>"Title"@21, :subtitle=>"Subtitle text"@28, :city=>"Kyiv"@43, :publisher=>"Publisher1"@49}

    @translate = TRANSLATE

    render :step_2
  end

  def step_2
    p params
      # Parameters: {"description"=>{"text"=>"rtyrtyrtyhtry"}, "items"=>{"author"=>"Author 1", "title"=>"Title", "subtitle"=>"Subtitle", "year"=>"2020", "city"=>"City", "publisher"=>"Publisher"}, "commit"=>"Підтвердити"}

    @description = params[:description]
    @items = params[:items]

    @available_styles = available_styles(@description[:style])
    @new_description = {style: @available_styles.first.last}
    @translate = TRANSLATE

    render :step_3
  end

  def step_3
    p params
    # Parameters: {"description"=>{"text"=>"rtyrtyrtyhtry", "style"=>"", "source"=>""}, "items"=>{"author"=>"Author 1", "title"=>"Title", "subtitle"=>"Subtitle", "year"=>"2020", "city"=>"City", "publisher"=>"Publisher"}, "new_description"=>{"style"=>"harvard"}, "commit"=>"Перетворити", "fname"=>""}

    @description = params[:description]
    @items = params[:items]
    @new_description = params[:new_description]

    @available_styles = available_styles(@description[:style])
    @translate = TRANSLATE

    # @result = "Can not "
    @result = new_description_book(@new_description[:style]) if @description["source"] == 'book'
    @result = new_description_part_of_book(@new_description[:style]) if @description["source"] == 'part_of_book'
    @result = new_description_article(@new_description[:style]) if @description["source"] == 'article'

  end

  private

  def proccess_authors
    authors = @items[:authors]
    @items.extract!(:authors)
    authors_index = 1

    # binding.pry
    if authors.is_a?(Hash)
      a = authors[:author]
      # new_key = "author#{authors_index}".to_sym
      return @items[:author] = "#{a[:last_name]} #{a[:first_name]} #{a[:second_name] if a[:second_name]}"
    end

    authors.each do |author|
      # binding.pry
      a = author[:author]
      new_key = "author#{authors_index}".to_sym
      @items[new_key] = "#{a[:last_name]} #{a[:first_name]} #{a[:second_name] if a[:second_name]}"

      authors_index += 1
    end

  end

  def proccess_editors
    editors = @items[:editors]
    @items.extract!(:editors)
    editors_index = 1

    # binding.pry
    if editors.is_a?(Hash)
      # a = editors[:editor]
      # new_key = "author#{authors_index}".to_sym
      return @items[:editor] = "#{editors[:last_name]} #{editors[:first_name]} #{editors[:second_name] if editors[:second_name]}"
    end

    editors.each do |editor|
      # binding.pry
      a = editor[:editor]
      new_key = "editor#{editors_index}".to_sym
      @items[new_key] = "#{a[:last_name]} #{a[:first_name]} #{a[:second_name] if a[:second_name]}"

      editors_index += 1
    end

  end


  def proccess_chapter
    chapter = @items[:chapter_name]
    @items.extract!(:chapter_name)

    book = @items[:book_name]
    @items.extract!(:book_name)

    @items[:chapter_name_title] = chapter[:title]
    @items[:chapter_name_subtitle] = chapter[:subtitle]

    @items[:book_name_title] = book[:title]
    @items[:book_name_subtitle] = book[:subtitle]
  end

    # rule(:author_apa) { word.as(:last_name) >> comma >> letter.as(:first_name) >> dot  }
    # rule(:authors_apa) { author_apa.as(:author) >> (comma >> author_apa.as(:author)).repeat }
    # rule(:apa) { authors_apa.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title >> dot >> word.as(:city) >> semidot >> sentence.as(:publisher) >> dot }


  def new_description_book(style)
    if style.include?("apa")
      return build_apa_book(@items)
    elsif style.include?("mla")
      return build_mla_book(@items)
    elsif style.include?("chicago")
      return build_chicago_book(@items)
    end
  end

  def available_styles(selected_style)
    styles = []

    %w(apa mla chicago).each do |style|
      next if selected_style == style
      styles << [TRANSLATE[style], style]
    end

    # [["APA", "apa"], ["MLA", "mla"], ["Chicago", "chicago"], ["ДСТУ 8302:2015", "dstu"]]
    styles
  end

  def build_apa_book(items)
    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[0]}, #{author_names[1].chars.first}.#{(' ' + author_names[2].chars.first + '.') if author_names[2]}"
      authors << author
    end

    authors_str = ""
    if authors.length == 1
      authors_str = authors.first
    elsif authors.length > 1 && authors.length < 8
      authors_str = authors.take(authors.size - 1).join(', ') + ', & ' + authors.last
    elsif authors.length >= 8
      authors_str = authors.take(6).join(', ') + ' ... ' + authors.last
    end

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]
    "#{authors_str} (#{items[:year]}). #{full_title}. #{items[:city]}: #{items[:publisher]}."
  end

    #   rule(:author_mla) { word.as(:last_name) >> comma >> word.as(:first_name)  }
    # rule(:authors_mla) { author_mla.as(:author) >> (comma >> author_mla.as(:author)).repeat >> dot }
    # rule(:mla) { authors_mla.as(:authors) >> full_title >> dot >> word.as(:city) >> semidot >> word.as(:publisher) >> comma >> year.as(:year) >> dot }

  def build_mla_book(items)
    # 1- 3
    # Прізвище1, Ім’я1, Ім’я2 Прізвище2, та Ім’я3 Прізвище3. Назва книги: Підназва. Номер видання. Місце видання: Видавництво, Рік. Тип публікації.
    # 4
    # Прізвище1, Ім’я1, та ін. Назва книги: Підназва. Номер видання. Місце видання: Видавництво, Рік. Тип публікації.

    # rule(:mla_book) { authors_mla.as(:authors) >> full_title_mla >> city.as(:city) >> semidot >> sentence.as(:publisher) >> comma >> year.as(:year) >> dot >> word.as(:publication_type) >> dot }

    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    # binding.pry

    authors_str = ""
    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length == 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.first + ', and ' + authors.last
    elsif authors.length >= 4
      authors_str = authors.first + ', et al'
    end

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]

    edition_number = " " + items[:edition_number] + '.' if items[:edition_number]
    publication_type = items[:publication_type] ? items[:publication_type] : 'Print'

    "#{authors_str}. #{full_title}.#{edition_number} #{items[:city]}: #{items[:publisher]}, #{items[:year]}. #{publication_type}."
  end

  def build_chicago_book(items)
    # Прізвище 1, Ім’я1, Ім’я2 Прізвище2, Ім’я3 Прізвище3, та Ім’я4 Прізвище4. Рік. Назва книги: Підназва. Місце видання: Видавництво.
    # ule(:chicago_book) { authors_mla.as(:authors) >> year.as(:year) >> dot >> full_title >> city.as(:city) >> semidot >> sentence.as(:publisher) >> dot }

    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length >= 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.take(authors.size - 1).join(', ') + ', and ' + authors.last
    end

    # first = authors.shift.split(' ')
    # authors_str = first[1] + ', ' + first[0] + ' ' + authors.take(authors.size - 1).join(', ') + ', and ' + authors.last

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]
    "#{authors_str}. #{items[:year]}. #{full_title}. #{items[:city]}: #{items[:publisher]}."
  end



  def new_description_part_of_book(style)
    if style.include?("apa")
      return build_apa_part_of_book(@items)
    elsif style.include?("mla")
      return build_mla_part_of_book(@items)
    elsif style.include?("chicago")
      return build_chicago_part_of_book(@items)
    end
  end

  def build_apa_part_of_book(items)
    # Прізвище автора глави, Ініціали. (Рік). Назва глави: Підназва. В Ініціали Прізвище редактора або укладача (відповідальність*), Назва книги: Підназва (номер видання). (cторінковий інтервал). Місце видання: Видавництво.

            # Farrell, S. E. (2009). Art. In D. Simmons (Ed.), New critical essays on Kurt Vonnegut (p. 91). New York, NY: Palgrave Macmillan.

    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[0]}, #{author_names[1].chars.first}.#{(' ' + author_names[2].chars.first + '.') if author_names[2]}"
      authors << author
    end

    authors_str = ""
    if authors.length == 1
      authors_str = authors.first
    elsif authors.length > 1 && authors.length < 8
      authors_str = authors.take(authors.size - 1).join(', ') + ', & ' + authors.last
    elsif authors.length >= 8
      authors_str = authors.take(6).join(', ') + ' ... ' + authors.last
    end

    editors = []
    editors_keys = items.keys
    editors_keys.delete_if { |item| !item.include?('editor') }

    editors_keys.each do |key|
      editor_names = items[key.to_sym].split(' ')
      editor = "#{editor_names[0]}, #{editor_names[1].chars.first}.#{(' ' + editor_names[2].chars.first + '.') if editor_names[2]}"
      editors << editor
    end

    editors_str = ""
    if editors.length == 1
      editors_str = editors.first
    elsif editors.length > 1 && editors.length < 8
      editors_str = editors.take(editors.size - 1).join(', ') + ', & ' + editors.last
    elsif editors.length >= 8
      editors_str = editors.take(6).join(', ') + ' ... ' + editors.last
    end

    chapter_full_title = items[:chapter_name_title]
    chapter_full_title << ": #{items[:chapter_name_subtitle]}" if items[:chapter_name_subtitle].length > 1

    book_full_title = items[:book_name_title]
    book_full_title << ": #{items[:book_name_subtitle]}" if items[:book_name_subtitle].length > 1

    edition_number = " (" + items[:edition_number] + ')' if items[:edition_number]

    pages_str = "(#{items[:pages].include?('-') ? 'pp.' : 'p.' } " + items[:pages] + ')' if items[:pages]

    "#{authors_str} (#{items[:year]}). #{chapter_full_title}. In #{editors_str} (Ed.), #{book_full_title}#{edition_number}. #{pages_str}. #{items[:city]}: #{items[:publisher]}."
  end


  def build_mla_part_of_book(items)
    # part of book
    # Прізвище автора частини, Ім’я. "Назва частини: Підназва." Назва книги: Підназва. Номер видання. Відомості про редактора. Місце видання: Видавництво, Рік. Сторінковий інтервал. Тип публікації.

    # Grosman, David. "Writing in the Dark." Burn This Book. Ed. Toni Morrison. New York: Harper, 2009. 22-32. Print.
    # Балашова, Єва. "Стратегічні дослідження." Пріоритети інвестиційного забезпечення. За ред. А. Сухорукова. Київ: Наукова думка, 2004. 5-9. Друк.

    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    editors = []
    editors_keys = items.keys
    editors_keys.delete_if { |item| !item.include?('editor') }

    editors_keys.each do |key|
      editor_names = items[key.to_sym].split(' ')
      editor = "#{editor_names[1]} #{editor_names[0]}"
      editors << editor
    end

    # binding.pry

    authors_str = ""
    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length == 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.first + ', and ' + authors.last
    elsif authors.length >= 4
      authors_str = authors.first + ', et al'
    end

    editors_str = " Ed. "
    if editors.length == 1
      first = editors.first.split(' ')
      editors_str << first[1] + ', ' + first[0]
    elsif editors.length == 2
      first = editors.shift.split(' ')
      editors_str << first[1] + ', ' + first[0] + ', and ' + editors.last
    elsif editors.length == 3
      first = editors.shift.split(' ')
      editors_str << first[1] + ', ' + first[0] + ' ' + editors.first + ', and ' + editors.last
    elsif editors.length >= 4
      editors_str << editors.first + ', et al'
    end

    chapter_full_title = items[:chapter_name_title]
    chapter_full_title << ": #{items[:chapter_name_subtitle]}" if items[:chapter_name_subtitle].length > 1

    book_full_title = items[:book_name_title]
    book_full_title << ": #{items[:book_name_subtitle]}" if items[:book_name_subtitle].length > 1

    edition_number = " " + items[:edition_number] + '.' if items[:edition_number]
    publication_type = items[:publication_type] ? items[:publication_type] : 'Print'

    "#{authors_str}. \"#{chapter_full_title}.\" #{book_full_title}.#{edition_number if edition_number}#{editors_str}. #{items[:city]}: #{items[:publisher]}, #{items[:year]}. #{items[:pages]}. #{publication_type}."
  end


  def build_chicago_part_of_book(items)
    # Прізвище автора частини книги, Ім’я. Рік. Назва частини книги. В Назва книги, відомості про редактора, Сторінковий інтервал частини книги. Місце видання: Видавництво.

    # Kelly, John. 2010. Seeing Red. In Anthropology and Global Counterinsurgency, edited by John Kelly, Beatrice Jauregui, Sean Mitchell, and Jeremy Walton, 67-83. Chicago: University of Chicago Press.
    # Балашова, Єва. 2014. Стратегічні дослідження. У Пріоритети інвестиційного забезпечення, під редакцією Андрія Сухорукова, 5-29. Київ: Наукова думка.

    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length >= 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.take(authors.size - 1).join(', ') + ', and ' + authors.last
    end


    editors = []
    editors_keys = items.keys
    editors_keys.delete_if { |item| !item.include?('editor') }

    editors_keys.each do |key|
      editor_names = items[key.to_sym].split(' ')
      editor = "#{editor_names[1]} #{editor_names[0]}"
      editors << editor
    end

    editors_str = " edited by "
    if editors.length == 1
      first = editors.first.split(' ')
      editors_str << first[1] + ', ' + first[0]
    elsif editors.length == 2
      first = editors.shift.split(' ')
      editors_str << first[1] + ', ' + first[0] + ', and ' + editors.last
    elsif editors.length >= 3
      first = editors.shift.split(' ')
      editors_str << first[1] + ', ' + first[0] + ' ' + editors.take(editors.size - 1).join(', ') + ', and ' + editors.last
    end

    chapter_full_title = items[:chapter_name_title]
    chapter_full_title << ": #{items[:chapter_name_subtitle]}" if items[:chapter_name_subtitle].length > 1

    book_full_title = items[:book_name_title]
    book_full_title << ": #{items[:book_name_subtitle]}" if items[:book_name_subtitle].length > 1

    "#{authors_str}. #{items[:year]}. #{chapter_full_title}. In #{book_full_title}, #{editors_str}, #{@items[:pages]}. #{items[:city]}: #{items[:publisher]}."
  end




  def new_description_article(style)
    if style.include?("apa")
      return build_apa_article(@items)
    elsif style.include?("mla")
      return build_mla_article(@items)
    elsif style.include?("chicago")
      return build_chicago_article(@items)
    end
  end

  def build_apa_article(items)
    # Прізвище, Ініціали. (Рік). Назва статті: Підназва. Назва журналу, Номер журналу, Сторінковий інтервал.

    # rule(:jornal_number_apa) { match('[0-9]').repeat >> lparen >> match('[0-9]').repeat >> rparen }
    # rule(:jornal_pp_apa) { match('[0-9]').repeat >> dash >> match('[0-9]').repeat }
    # rule(:apa_article) { authors_apa.as(:authors) >> lparen >> year.as(:year) >> rparen >> dot >> full_title >> dot >> sentence.as(:journal) >> comma >> jornal_number_apa.as(:jornal_number) >> comma >> jornal_pp_apa.as(:jornal_pp) >> dot }


    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[0]}, #{author_names[1].chars.first}.#{(' ' + author_names[2].chars.first + '.') if author_names[2]}"
      authors << author
    end

    authors_str = ""
    if authors.length == 1
      authors_str = authors.first
    elsif authors.length > 1 && authors.length < 8
      authors_str = authors.take(authors.size - 1).join(', ') + ', & ' + authors.last
    elsif authors.length >= 8
      authors_str = authors.take(6).join(', ') + ' ... ' + authors.last
    end

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]
    "#{authors_str}. (#{items[:year]}). #{full_title}. #{@items[:journal]}, #{@items[:journal_number]}, #{@items[:pages]}."
  end

  def build_mla_article(items)
    # Прізвище, Ім’я. "Назва статті: Підназва." Назва журналу Номер журналу (Рік): Сторінковий інтервал. Тип публікації.

    # rule(:full_title_mla_article) { quote >> sentence.as(:title) >> ( semidot >> sentence.as(:subtitle) ).maybe >> dot >> quote }
    # rule(:mla_article) { authors_mla.as(:authors) >> full_title_mla_article.as(:article_name) >> sentence.as(:journal) >> space >> lparen >> year.as(:year) >> rparen >> semidot >> space >> mla_pages.as(:pages) >> dot >> word.as(:publication_type) >> dot }


    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    authors_str = ""
    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length == 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.first + ', and ' + authors.last
    elsif authors.length >= 4
      authors_str = authors.first + ', et al'
    end

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]

    publication_type = items[:publication_type] ? items[:publication_type] : 'Print'

    "#{authors_str}. \"#{full_title}.\" #{@items[:journal]} #{@items[:journal_number]} (#{@items[:year]}): #{items[:pages]}. #{publication_type}."
  end

  def build_chicago_article(items)
    # Прізвище, Ім`я. Рік. “Назва статті: Підназва.” Назва журналу Номер журналу: Сторінковий інтервал всієї статті.

    # rule(:jornal_number_chicago) { match('[0-9]').repeat >> ( lparen >> match('[0-9]').repeat >> rparen ).maybe }
    # rule(:chicago_article) { authors_mla.as(:authors) >> year.as(:year) >> dot >> full_title_mla_article >> sentence.as(:journal) >> jornal_number_chicago.as(:jornal_number) >> semidot >> jornal_pp_apa.as(:jornal_pp) >> dot }


    authors = []
    authors_keys = items.keys
    authors_keys.delete_if { |item| !item.include?('author') }

    authors_keys.each do |key|
      author_names = items[key.to_sym].split(' ')
      author = "#{author_names[1]} #{author_names[0]}"
      authors << author
    end

    if authors.length == 1
      first = authors.first.split(' ')
      authors_str = first[1] + ', ' + first[0]
    elsif authors.length == 2
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ', and ' + authors.last
    elsif authors.length >= 3
      first = authors.shift.split(' ')
      authors_str = first[1] + ', ' + first[0] + ' ' + authors.take(authors.size - 1).join(', ') + ', and ' + authors.last
    end

    # first = authors.shift.split(' ')
    # authors_str = first[1] + ', ' + first[0] + ' ' + authors.take(authors.size - 1).join(', ') + ', and ' + authors.last

    full_title = items[:title]
    full_title << ": #{items[:subtitle]}" if items[:subtitle]

    "#{authors_str}. #{@items[:year]}. \" #{full_title}.\" #{items[:jornal]} #{items[:journal_number]}: #{items[:pages]}."
  end




end