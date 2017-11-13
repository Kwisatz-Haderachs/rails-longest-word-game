require 'open-uri'

class LongestWordController < ApplicationController

  def generate_grid
    @grid = []
    letters = ("A".."Z").to_a

    (0...12).each { |_| @grid << letters.sample }
    return @grid
  end

  def word?(attempt)
    url = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    dict_hash = JSON.parse(url.read)
    dict_hash["found"]
  end

  def game
    generate_grid
    @start_time = Time.now
  end

  def count_freq(array)
    result = Hash.new(0)

    array.each do |s|
      if result.key?(s)
        result[s] += 1
      else
        result[s] = 1
      end
    end
    return result
  end

  def conform?(attempt, grid)
    grid = grid.split(" ").to_a
    grid = grid.map { |e| e.downcase }
    grid_freq = count_freq(grid)
    condition = true

    count_freq(attempt.split()).each do |key, value|
      if value > grid_freq[key]
        condition = false
        break
      end
    end
    return condition
  end


  def score
    @attempt = params[:attempt]
    @grid = params[:grid_instance]
    @start_time = params[:start_time]
    @end_time = Time.now
    word?(@attempt)
    conform?(@attempt, @grid)


    if !word?(@attempt)
      @message = "not an english word"
    else
      @duration = ((Time.now.to_i)- (@end_time.to_i- @start_time.to_i))
      @message = "Well Done!"
      @your_score = 1000 * @attempt.length
    end
  end
end
