# AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA PORRA
def ingredient_search(full_ingredient_string)
  arr = full_ingredient_string.split(' ')
  alpha = ('A'..'Z').to_a
  arr.shift until alpha.include? arr.first[0]
  arr.join(' ')
end
puts 'Cleaning records'
Cocktail.destroy_all
puts "Cocktails: #{Cocktail.count}"
Ingredient.destroy_all
puts "Ingredients: #{Ingredient.count}"
Dose.destroy_all
puts "Doses: #{Dose.count}"
puts '-' * 100
puts 'Started the Seed'
puts 'Will attempt to scrape https://www.socialandcocktail.co.uk/top-100-cocktails/'
puts '-' * 100
puts 'Looking for Cocktails:'
html_file = open('https://www.socialandcocktail.co.uk/top-100-cocktails/').read
html_doc = Nokogiri::HTML(html_file)
html_doc.search('.recipe_summary h3').each do |cocktail|
  cocktail_name = cocktail.text.strip
  new_cocktail = Cocktail.new(
    name: cocktail_name,
    description: RobertoBarros.in_ingrish
  )
  new_cocktail.remote_photo_url = "https://source.unsplash.com/random?#{new_cocktail.name}"
  if new_cocktail.valid?
    new_cocktail.save
    puts "#{Cocktail.count}: #{new_cocktail.name} - #{new_cocktail.description}"
    puts ''
  else
    puts '----------- Something went wrong ----------'
    puts new_cocktail.errors.messages
    puts ''
  end
end
puts '-' * 100
puts 'And Now for the Ingredients:'
html_doc.search('.content-appear p').each_with_index do |ingredient_tag, ingredient_index|
  next unless ingredient_index.even?
  ingredient_strings_arr = ingredient_tag.text.strip.split(/[\d+\/]+/)
  ingredient_strings_arr.reject! { |string| string == ' '}
  ingredient_strings_arr.reject! { |string| string == ''}
  p ingredient_strings_arr
  assholes = [' squeezed lemon', ' `', ' ml', ' ml ']
  ingredient_strings_arr.each do |ingredient_string|
    next if assholes.include? ingredient_string
    new_name = ingredient_search(ingredient_string)
    new_ingredient = Ingredient.new(name: new_name)
    if new_ingredient.save
      puts "#{Ingredient.count}: #{new_ingredient.name}"
    else
      puts '----------- Something went wrong ----------'
    end
  end
end
puts '-' * 100
puts 'Generating Random Doses'
Cocktail.all.each do |cocktail|
  10.times do
    measures = [
      'cups',
      'oz',
      'tea spoons',
      'soup spoons',
      '1/2 cup',
      '1/4 cup'
    ]
    ammount = "#{rand(1..8)} #{measures.sample}"
    dose = Dose.new(
      cocktail: cocktail,
      ingredient: Ingredient.all.sample,
      description: ammount
    )
    if dose.save
      puts "#{Dose.count}: #{dose.cocktail.name} - #{dose.description} of #{dose.ingredient.name}"
    else
      puts '----------- Something went wrong ----------'
    end
  end
end
puts 'Ended!'
puts '-' * 100
puts 'And you now are the proud owner of: '
puts "#{Cocktail.count} cocktails,"
puts "#{Ingredient.count} ingredients,"
puts "#{Dose.count} different doses!"
# HAHAHAHAHAHAHAHHAHAHAHAH
