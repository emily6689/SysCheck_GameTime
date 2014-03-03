
require "CSV"
require "pry"
require "sinatra"
require 'shotgun'

game_data = []
team_data = Hash.new(0)


CSV.foreach('game_data.csv', headers:true) do |row|
 game_data << row.to_hash
end



#This code sets up and orders all the win/loss data for each team
#in a seperate hash called team_data
game_data.each do |game|
  team_data[game["home_team"]] = {wins: 0, losses: 0}
  team_data[game["away_team"]] = {wins: 0, losses: 0}
end
game_data.each do |game|
  if  game["home_score"].to_i > game["away_score"].to_i
      team_data[game["home_team"]][:wins]   += 1
      team_data[game["away_team"]][:losses] += 1
    elsif game["home_score"].to_i < game["away_score"].to_i
      team_data[game["home_team"]][:losses] += 1
      team_data[game["away_team"]][:wins]   += 1
  end
end
team_data = Hash[team_data.sort_by {|key, value| [-value[:wins], value[:losses]]}]
#Yay! now all the data is set up and in order.


get '/' do
  @team_data = team_data
  erb :leaderboard
end

get'/:teamname' do
  @team_name = params[:teamname]
  @team_data = team_data
  @game_data = game_data
  erb :teaminfo
end

set :views, File.dirname(__FILE__) + '/views'










