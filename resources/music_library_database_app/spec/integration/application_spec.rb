require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  def reset_albums_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  describe AlbumRepository do
    before(:each) do 
      reset_albums_table
    end

    context 'GET /albums' do
      it 'should return the list of albums' do
        response = get('/albums')
        
        expect(response.status).to eq(200)
        expect(response.body).to include('<a href="albums/1">Doolittle</a><br />')
        expect(response.body).to include('<a href="albums/2">Surfer Rosa</a><br />')


      end 
    end

    context 'GET /albums/:id' do
      it 'should return the content for album 1' do
        response = get('/albums/1')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Doolittle</h1>')
        expect(response.body).to include('Release year: 1989')
        expect(response.body).to include('Artist: Pixies')
      end
    end

    context 'POST /albums' do
      it 'should create a new albums' do
        response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        # response = get('/albums')
        # expect(response.body).to include('OK Computer')
      end
    end

 end

  def reset_artists_table
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  describe ArtistRepository do
    before(:each) do 
      reset_artists_table
    end

    context 'GET /artists' do
      it 'returns a list of artists' do
        response = get('/artists')
        
        expect(response.status).to eq(200)
        expect(response.body).to include('<a href="artists/1">Pixies</a><br />')
      end
    end

    context 'GET /artists/:id' do
      it 'returns artist 1' do
        response = get('/artists/1')

        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Pixies</h1>')
      end
    end

    context 'POST /artists' do
      it 'should create a new artist' do
        response = post('/artists', name: 'Beyonce', genre: 'Pop')

        expect(response.status).to eq(200)
        expect(response.body).to eq('')

        response = get('/artists')
        expect(response.body).to include('Beyonce')
      end
    end

  end
end
