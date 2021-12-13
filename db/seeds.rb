# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(username:"admin",nickname:"admin",password:"tiewza567",password_confirmation:"tiewza567",admin:"true",status:2)
3.times do |i|
	title = Faker::Lorem.sentence(word_count: 5, random_words_to_add: 7)
	body = Faker::Lorem.paragraph_by_chars(number: 1500)
	views = Faker::Number.between(from:1,to:500)
	Post.create!(title: title,body:body,user_id: 1,views:views)
end

10.times do |i|
	User.create!(username:"#{i+2}",nickname:"#{i+2}",password:"#{i+2}",password_confirmation:"#{i+2}",status:1)
	Follow.create!(follower_id:i+2,followee_id:1)
end

10.times do |i|
	title = Faker::Lorem.sentence(word_count: 5, random_words_to_add: 7)
	body = Faker::Lorem.paragraph_by_chars(number: 1500)
	views = Faker::Number.between(from:1,to:500)
	#comment
	msg = Faker::Lorem.sentence(word_count: 5, random_words_to_add: 7)
	Post.create!(title: title,body:body,user_id: i+2,views:views)
	Comment.create!(msg:msg,user_id:1,post_id:i+2)
end
