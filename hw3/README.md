BDD & Cucumber
===========================================

# Part 0: Setting Up Cucumber

First, this homework requires that you have successfully completed Homework 2, as we will be building on top of that here.  If you had issues completing HW2, see the HW3 announcement on Piazza for advice on what to do moving forward.

In order to use cucumber, we first need to install it into our current rottenpotatoes app.  Cucumber is just a gem like any other, so we could just add 'cucumber' to our Gemfile.  However, there is also a gem called 'cucumber-rails' which includes cucumber and adds some nice rails scripts to use on top.  In addition, we need a gem called 'database_cleaner' to help us setup a clean database environment for when we run our tests.  Your Gemfile should have a section that looks like this:

```ruby
group :development,:test do
  # ... other gems
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
end
```

Now run `bundle install --without production` to install these new dependencies.

At this point you still need to setup the cucumber file scaffolding.  Because we are using the cucumber-rails gem, there is a simple command to do this for us:   `rails generate cucumber:install`

Now, you need to install some skeleton files that we provide.  There is a tarball with skeleton files that you can get here. Untar the tarball; it should contain a directory called 'features'.  Just merge that into the 'features' directory that already exists in your rottenpotatoes app.

Here is a brief breakdown of the files we are providing to you:

* `step_definitions/web_steps.rb`: Some low-level step definitions that handle tasks like clicking buttons and filling in forms.  You should not edit this file. But do look at it and be sure to understand its basic purpose and how to use it.

* `step_definitions/movie_steps.rb`: Higher level cucumber step definitions that you will need to implement.

* `filter_movie_list.feature`: A feature file with scenarios you will be writing.

* `sort_movie_list.feature`: A feature file with scenarios you will be writing.

*HISTORICAL NOTE:  the file web_steps.rb used to be included in distributions of Cucumber.  The maintainers decided that using such low-level steps encourages developers to write complicated scenarios, so they removed it from Cucumber by default.  We are providing it to you because we feel it is a good set of reference steps to browse through to get a feel for how Cucumber and Capybara work.  In general, for example when you start your own projects, you should NOT use the steps provided in web_steps.rb.  For more information, read the comments in web_steps.rb.  For this homework, feel free to use it (or avoid it if you're feeling adventurous).*


# Part 1: Create a declarative scenario step for adding movies

### THE GOAL OF BDD IS TO EXPRESS BEHAVIORAL TASKS RATHER THAN LOW-LEVEL OPERATIONS.

The background step of all the scenarios in this homework requires that the movies database contain some movies. It would go against the goal of BDD to do this by writing scenarios that spell out every interaction required to add a new movie, since adding new movies is **not** what these scenarios are about.

Recall that the Given steps of a user story specify the initial state of the system—it doesn't matter how the system got into that state. For part 1, therefore, you will create a step definition that will match the step `Given the following movies exist` in the `Background` section of both `sort_movie_list.feature` and `filter_movie_list.feature`. (Later in the course, we will show how to DRY out the repeated Background sections in the two feature files.)

Add your code in the `movie_steps.rb` step definition file. You can just use ActiveRecord calls to directly add movies to the database; it's OK to bypass the GUI associated with creating new movies, since that's not what these scenarios are testing.

SUCCESS is when all Background steps for the scenarios in `filter_movie_list.feature` and `sort_movie_list.feature` are passing Green.

**Note**: If you have access to the SaaS textbook and have never used Cucumber before we strongly recommend that you work step by step through the code in chapter 7 of the Engineering Software as a Service textbook.  We also have a series of free screencasts that walk through the code in that chapter, which you can view even if you don't have the textbook


# Part 2: Happy paths for filtering movies

0. Complete the scenario `restrict to movies with 'PG' or 'R' ratings` in `filter_movie_list.feature`. You can use existing step definitions in `web_steps.rb` to check and uncheck the appropriate boxes, submit the form, and check whether the correct movies appear (and just as importantly, movies with unselected ratings do not appear).

0. Since it's tedious to repeat steps such as When I check the 'PG' checkbox, And I check the 'R' checkbox, etc., create a step definition to match a step such as:
`When I check the following ratings: G, PG, R`

   This single step definition should only check the specified boxes, and leave the other boxes as they were.

   **HINT**: this step definition can reuse existing steps in web_steps.rb, as shown in the example in Section 7.9 of the ESaaS textbook.

0. For the scenario `all ratings selected`, it would be tedious to use `And I should` see to name every single movie. That would detract from the goal of BDD to convey the behavioral intent of the user story. To fix this, create step definitions that will match steps of the form: 
`Then I should see all the movies in movie_steps.rb. `

   **HINT**: Consider counting the number of rows in the table to implement these steps. If you have computed rows as the number of table rows, you can use the assertion 
   `assert(rows == value, rows.to_s + " does not equal " + value.to_s)` 
   to fail the test in case the values don't match.
   *Update: You no longer need to implement the scenario for no ratings selected.*

0. Use your new step definitions to complete the scenario `all ratings selected`. SUCCESS is when all scenarios in `filter_movie_list.feature` pass with all steps green.


# Part 3: Happy paths for sorting movies by title and by release date

0. Since the scenarios in `sort_movie_list.feature` involve sorting, you will need the ability to have steps that test whether one movie appears before another in the output listing. Create a step definition that matches a step such as 
`Then I should see "Aladdin" before "Amelie"`

   **HINTS:**
   * page is the Capybara method that returns whatever came back from the app server.
   * page.body is the page's HTML body as one giant string.
   * A regular expression could capture whether one string appears before another in a larger string, though that's not the only possible strategy.

0. Use the step definition you create above to complete the scenarios `sort movies alphabetically` and `sort movies in increasing order` of release date in `sort_movie_list.feature`.

SUCCESS is all steps of all scenarios in both feature files passing Green.


# Submission

To submit the code for your assignment, please submit a .tar.gz compressed archive file containing just your "features" directory. The command for doing this in a UNIX environment is:
`tar czf features.tar.gz features/`

Please make sure that the "features" directory is contained in the archive. For example, unarchiving your submission should create a directory named "features" in the current working directory. It should not extract all your features directly into the current working directory.

---------------------------------------------------

Please also note that you need to get your cucumber features passing on your local machine before attempting to submit to the autograder. If there is any problem running your cucumber tests the autograder will return with the response "**** FATAL: invalid cucumber results". If you get this response, please double check that all your cucumber tests are green in your local VM or EC2 instance.
