# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Book
apa_book = [
  "Jackson, L. M. (2019). The psychology of prejudice: From attitudes to social action (2nd ed.). American Psychological Association.",
  "Sapolsky, R. M. (2017). Behave: The biology of humans at our best and worst. Penguin Books.",
  "Bennett, D. (2011). Strategies and Techniques in Teaching Reading. Boston: Goucher College.",
  "Carroll, J.P. (1966). Some neglected relationships in reading and language. Elementary English, 43, 511-582.",
  "Graves, M., Juel, C., Graves, B., & Dewitz, P. (2011). Teaching reading in the 21st century, motivating all learners. Boston, Massachusetts: Allyn & Bacon.",
  "Mesmer, H.A.E. & Griffith, P.L. (2005). Everybody's selling it: But just what is explicit, systematic phonics instruction? International Reading Association, 366-376.",
  "Pressley, M. & Afflerbach, P. (1995). Verbal protocols of reading: The nature of constructively responsive reading. Mahwah, NJ: Erlbaum.",
  "Wasik, B.A., Bond, M.A., & Hindman, A. (2006). The Effects of a Language and Literacy Intervention on Head Start Children and Teachers. Journal of Educational Psychology, 98, 63-74.",
  "Wells, A. (2009). Metacognitive therapy for anxiety and depression in psychology. Guilford Press.",
  "Matthews, J. (1999). The art of childhood and adolescence: The construction of meaning. Falmer Press.",
  "Rosenthal, R., Rosnow, R. L., & Rubin, D. B. (2000). Contrasts and effect sizes in behavioral research: A correlational approach. Cambridge University Press."
  # "",
  # "",
  # "",
  # "",
  # ""
]

apa_book.each do |book|
  # text:string correctness:boolean style:string source:string defined_style:string defined_source:string
  Research.create(text: book, style: "APA", source: "Book", correctness: true)
end

mla_book = [
  "Sweeney, John. 'The New Internationalism.' Global Backlash: Citizen Initiatives in a Just World Economy, edited by Robin Broad, MacMillan Press, 2002",
  "",
  "",
  "",
  "",
  "",
  ""
]

chicago_book = [
  "Sweeney, John. 'The New Internationalism.' Global Backlash: Citizen Initiatives in a Just World Economy, edited by Robin Broad, MacMillan Press, 2002",
  "",
  "",
  "",
  "",
  "",
  ""
]

harvard_book = [
  ""
]

dstu_book = [

]