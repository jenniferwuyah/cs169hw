BDD & TDD Cycle
===========================================

In this assignment you will use a combination of Behavior-Driven Design (BDD) and Test-Driven Development (TDD) with the Cucumber and RSpec tools to add a "find movies with same director" feature to RottenPotatoes, and deploy the resulting app on Heroku.

Again, you will be building off of previous homeworks, so continue to work in your RottenPotatoes app.

**Please now follow the instructions below to get setup:**


0. Change into the rottenpotatoes directory

0. In your Gemfile, add the following lines to your 'test' and 'development' groups:
   * gem 'rspec-rails', '~> 2.14.0'
   * gem 'simplecov'

0. In your Gemfile, add the following lines to your 'assets' group:
   * gem 'therubyracer'
   * gem 'sass-rails'
   * gem 'coffee-rails'

0. Run `bundle install --without production` to make sure all gems are properly installed.

0. Run `bundle exec rake db:migrate` to apply database migrations.

0. Finally, run this command to set up the RSpec directory (under spec/), allowing overwrite of any existing files: "rails generate rspec:install"

You can make sure that RSpec is installed correctly by running "bundle exec rspec".  This should have very little output; since you have no RSpec tests yet it should just report that no tests ran.


# Part 1: Add a Director field to Movies

Create and apply a migration that adds the Director field to the movies table. The director field should be a string containing the name of the movie’s director. HINT: use the `add_column` method of `ActiveRecord::Migration` to do this, or use a smart migration name to have Rails interpret your migration and build it for you: [http://guides.rubyonrails.org/v3.2.13/migrations.html]

In order for mass assignment to continue working, add `:director` to the `attr_accessibl`e arguments in the `movie.rb` model.

Remember that once the migration is applied, you also have to do `rake db:test:prepare` to load the new post-migration schema into the test database in addition to `rake db:migrate` for the development database!


# Part 2: Use BDD+TDD to get new scenarios passing

We've provided [three Cucumber scenarios](http://pastebin.com/L6FYWyV7) to drive creation of the happy path of Search for Movies by Director. The first lets you add director info to an existing movie, and doesn't require creating any new controller actions (but does require modifying existing views, and will require creating a new step definition and possibly adding a line or two to `features/support/paths.rb`).

The second lets you click a new link on a movie details page "Find Movies With Same Director", and shows all movies that share the same director as the displayed movie.
For this you'll have to modify the existing Show Movie view, and you'll have to add a route, view and controller method for Find With Same Director.

The third handles the sad path, when the current movie has no director info but we try to do "Find with same director" anyway.

Going one Cucumber step at a time, use RSpec to create the appropriate controller and model specs to drive the creation of the new controller and model methods. At the least, you will need to write tests to drive the creation of:

* a RESTful route for Find Similar Movies (HINT: use the 'match' syntax for routes as suggested in "Non-Resource-Based Routes" in Section 4.1 of ESaaS)

* a controller method to receive the click on "Find With Same Director", and grab the id (for example) of the movie that is the subject of the match (i.e. the one we're trying to find movies similar to)

* a model method in the Movie model to find movies whose director matches that of the current movie

It's up to you to decide whether you want to handle the sad path of "no director" in the controller method or in the model method, but you must provide a test for whichever one you do. Remember to include the line `require 'spec_helper'` at the top of your`*_spec.rb` files.

We want you to report your code coverage as well.

Add the following lines to the TOP of `spec/spec_helper.rb` and` features/support/env.rb`:

`require 'simplecov'`
`SimpleCov.start 'rails'`
  
Now when you run `rake spec` or `rake cucumber`, SimpleCov will generate a report in a directory named `coverage/`. Since both RSpec and Cucumber are so widely used, SimpleCov can intelligently merge the results, so running the tests for Rspec does not overwrite the coverage results from SimpleCov and vice versa. See the [ESaaS screencast](http://vimeo.com/34754907) for step-by-step instructions on setting up SimpleCov.


# Submission

Here are the instructions for submitting HW4. Submission will be similar to HW3. You will submit a `.tar.gz` file with various directories of your app:

* `app/`
* `config/`
* `db/migrate/YOUR_DIRECTOR_MIGRATION_FILE`
* `features/`
* `spec/`
* `Gemfile`
* `Gemfile.lock`

If you modified any other files, please include them too. If you are using the Virtual Machine, navigate to the root directory for HW4 and run

`tar czf hw4.tar.gz app/ config/ db/migrate/YOUR_DIRECTOR_MIGRATION_FILE features/ spec/ Gemfile Gemfile.lock`

This will create the file `hw4.tar.gz`, which you will submit. Of course, you should replace 'YOUR_DIRECTOR_MIGRATION_FILE' with the relevant file name.

