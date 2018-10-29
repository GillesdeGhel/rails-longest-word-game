require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    8.times do
      @grid << ('a'..'z').to_a.sample
    end
  end

  def score
    return @score = "Sorry but #{params[:word]} cannot be built from #{params[:grid].split}" unless check_grid(params[:grid], params[:word])

    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word = JSON.parse(open(url).read)
    if word["found"]
      return @score = "Congratulation, #{params[:word].upcase} is an english word"
    else
      return @score = "Sorry but #{params[:word]} does not seem to be an english word"
    end
  end

  def check_grid(grid, attempt)
    grid_hash = Hash.new(0)
    attempt_hash = Hash.new(0)
    grid.split(//).each { |letter| grid_hash[letter] += 1 }
    attempt.split(//).each { |letter| attempt_hash[letter] += 1 }
    attempt_hash.all? { |k, _v| attempt_hash[k] <= grid_hash[k] }
  end
end
