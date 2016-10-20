begin

# add default admin user
user = User.new
user.email = 'test@test.com'
user.first_name = 'Jae'
user.last_name = 'Lee'
user.username = 'admin'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'admin'
user.provider = 'email'
user.save

user = User.new
user.email = 'test1@test.com'
user.first_name = 'Dennis'
user.last_name = 'Lee'
user.username = 'ibanzajoe'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'member'
user.provider = 'email'
user.gender = 'male'
user.occupation = 'Computer Programmer'
user.language = 'bilingual'
user.location = 'los angeles'
user.immigration = nil
user.birth_month = 10
user.birth_day = 10
user.birth_year = 1984
user.height_ft = 6
user.height_in = 2
user.have_pic = true
user.self_summary = "I made this website"
user.paid = true
user.save
picture = Picture.new
picture.user_id = user.id
picture.image_url = "/images/6666779932101598483.jpg"
picture.main_pic = true
picture.save

user = User.new
user.email = 'test2@test.com'
user.first_name = 'Sara'
user.last_name = 'So'
user.username = 'sara1240'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'member'
user.provider = 'email'
user.gender = 'female'
user.occupation = 'Cook'
user.language = 'korean'
user.location = 'somewhere in ca'
user.immigration = nil
user.birth_month = 2
user.birth_day = 28
user.birth_year = 1988
user.height_ft = 5
user.height_in = 2
user.have_pic = true
user.self_summary = "Hello, I don't have much to say! Just ask me!"
user.paid = true
user.save
picture = Picture.new
picture.user_id = user.id
picture.image_url = "/images/9399206371085161598.jpg"
picture.main_pic = true
picture.save

user = User.new
user.email = 'test3@test.com'
user.first_name = 'James'
user.last_name = 'Lee'
user.username = 'uptownhr'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'member'
user.provider = 'email'
user.gender = 'male'
user.occupation = 'programmer'
user.language = 'english'
user.location = 'culver city'
user.immigration = 'citizen'
user.birth_month = 10
user.birth_day = 31
user.birth_year = 1985
user.height_ft = 5
user.height_in = 10
user.have_pic = true
user.self_summary = "I like to go hiking on the weekends and I love to play with my dog"
user.paid = true
user.save
picture = Picture.new
picture.user_id = user.id
picture.image_url = "/images/uptownhr.jpg"
picture.main_pic = true
picture.save

user = User.new
user.email = 'test4@test.com'
user.first_name = 'Jennifer'
user.last_name = 'Kim'
user.username = 'jennylove10'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'member'
user.provider = 'email'
user.gender = 'female'
user.occupation = 'designer'
user.language = 'english'
user.location = 'ktown'
user.immigration = 'citizen'
user.birth_month = 3
user.birth_day = 3
user.birth_year = 1988
user.height_ft = 5
user.height_in = 5
user.have_pic = true
user.self_summary = "I like to play League of Legends"
user.paid = true
user.save
picture = Picture.new
picture.user_id = user.id
picture.image_url = "/images/2969182922332883296.jpg"
picture.main_pic = true
picture.save


# add blog post

#for num in 1..69 do
post = Post.new
post.user_id = 1
post.title = "Why I created Honeybadger"
post.teaser = "One day I said to myself enough is enough. I have been turmoiled by lack of quality minimal frameworks to get me started on new projects. And thus ..."
post.content = "I wanted a simple and lightweight blogging / CMS framework for Ruby and no matter how much I looked, I just could not find one. "
post.created_at = Time.now
post.save
#end

rescue Exception => e
    puts "seeds already ran"
    p e.message
end