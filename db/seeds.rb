puts 'Cleaning records'
Cocktail.destroy_all
puts "Cocktails: #{Cocktail.count}"
Ingredient.destroy_all
puts "Ingredients: #{Ingredient.count}"
Dose.destroy_all
puts "Doses: #{Dose.count}"
puts '-' * 100

puts 'Started the Seed'

puts 'Will attempt to scrape https://gruetwinery.com/7/cocktail-recipes'

html_file = open('https://gruetwinery.com/7/cocktail-recipes').read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.cocktail h3').each do |cocktail|
  cocktail_name = cocktail.text.strip
  new_cocktail = Cocktail.new(name: cocktail_name)
  if new_cocktail.valid?
    new_cocktail.save
    puts new_cocktail.name
  else
    puts 'Something went wrong'
  end
end

puts "Ended and you now are the proud owner of #{Cocktail.count} cocktails!"
