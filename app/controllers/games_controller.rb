require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:grid] = @grid
  end

  def score
    @grid = session[:grid]
    @word = params[:word].upcase
    if included?(@word, @grid)
      if english_word?(@word)
      @answer = "Congratulations #{@word} is a valid english word!"
      else
      @answer = "Sorry but #{@word} does not seem to be an valid english word"
      end
    else
    @answer = "sorry but #{word} cannot be built of of #{@grid}"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
