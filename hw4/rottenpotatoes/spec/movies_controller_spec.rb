require 'spec_helper'

describe MoviesController, :type => :controller do
  
  describe 'Update Director Field for Movie' do
    
    before :each do
      @m = double(Movie)
      Movie.stub(:find).with('1').and_return(@m)
    end

    it 'should go to the edit page for Movie' do
      get :edit, :id => '1'
      expect(response).to be_success
    end

    it 'should update the attributes for movie and redirect' do
      @m.stub(:update_attributes!).and_return(true)
      @m.stub(:title)
      @m.stub(:director)
      put :update, :id => '1'
      expect(response).to redirect_to(movie_path(@m))
    end
  end

  describe 'Director Search Happy Path' do

    before :each do
      @m = double(Movie, :title => "Star Wars", :director => "George Lucas", :id => "1")
      Movie.stub(:find).with("1").and_return(@m)
    end

    it 'should go to the details page for Movie' do
      get :show, :id => '1'
      expect(response).to be_success
    end

    it 'should go to Similar Movies page' do
      @moreMocks = [double(Movie), double(Movie)]
      Movie.stub(:find_by_director).with(@m).and_return(@moreMocks)
      get :similar, :movie_id => "1"
      expect(response).to be_success
    end

    it 'should render similar template' do
      Movie.stub(:find_by_director).and_return(@m)
      get :similar, :movie_id => "1"
      response.should render_template('similar')
      assigns(:movies).should == @m
    end

  end

  describe 'Director Search Sad Path' do
    before :each do
      @m = double(Movie, :title => "Alien", :director => nil, :id => "1")
      Movie.stub(:find).with("1").and_return(@m)
    end

    it 'should render index template with flash message' do
      get :similar, :movie_id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

  describe 'create and destroy' do
    before :each do
      @m = double(Movie)
      @m.stub(:title)
    end

    it 'should create a movie' do
      Movie.should_receive(:create!).and_return(@m)
      post :create, :movie => @m
      expect(response).to redirect_to(movies_path)
    end

    it 'should destroy a movie' do
      Movie.should_receive(:find).with("1").and_return(@m)
      @m.should_receive(:destroy)
      post :destroy, :id => "1"
      expect(response).to redirect_to(movies_path)
    end
  end

  describe 'filter movies by rating' do
    it 'should redirect once selected ratings are changed' do
      get :index, :ratings => {:PG => 1, :R => 1}
      expect(response).to be_success
    end

    it 'should redirect to select all ratings if none is selected' do
      get :index, :ratings => nil
      expect(response).to be_success
      expect(session[:ratings]).to eq(Hash[Movie.all_ratings.map {|x| [x, 1]}])
    end

    it 'should redirect back with session ratings' do
      session[:ratings] = {:PG => 1, :R => 1}
      get :index
      expect(response).to redirect_to(movies_path(:ratings => session[:ratings]))
    end
  end

  describe 'sort movies by title or release date' do
    it 'should be able to sort by title' do
      get :index, {:sort => 'title'}
      expect(response).to be_success
    end

    it 'should be able to update sort order if changed' do
      session[:sort] = 'title'
      get :index, {:sort => 'release_date'}
      expect(session[:sort]).to eq('release_date')
      expect(response).to be_success
    end

    it 'should be able to sort by release date' do
      get :index, {:sort => 'release_date'}
      expect(response).to be_success
    end

    it 'should be able to go back with same sorting setting' do
      session[:sort] = 'title'
      get :index
      expect(response).to redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
    end

  end

end
