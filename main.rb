# distools: useful discord utilities in bot form, written in ruby with love
# by the Windev Systems Foundation
# 
# help: hwalker@windevstudios.com
# code: gh.windev.systems/hwalker/distools
require "discorb"
require "dotenv"
require "etc"
systemUsername = Etc.getpwuid(Process.uid).name
uname = Etc.uname

File.foreach("index.txt") { |line| puts line }
Dotenv.load  # Loads .env file
puts "loaded .env and thus i am proceeding"
client = Discorb::Client.new  # Create client for connecting to Discord
# activity = Discorb::Activity.new # Activiteh!!!

# Slash commands
client.slash("hello", "hello") do |interaction|
  interaction.post("`world`\n\n`distools` by Winfinity\#1252\n`ruby ver: #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}`\n`discorb ver: #{Discorb::VERSION}`\n`OS: #{uname[:sysname]} #{uname[:release]}`\n`running as: #{systemUsername}`", ephemeral: false)
end

client.slash("help", "gives you my commands") do |interaction|
  interaction.post("Hi, I'm `distools` a bot made with :heart: by **Winfinity**.\nAs of right now my only two commands are `help` and `hello` but there will be more soon!!", ephemeral: false)
end

# Gonna see if this works. Ctrl C does not seem like a good way to end a bot so I
# think I will gracefully stop it
client.slash("stop", "[owner only] shutting down") do |interaction|
  interaction.post("coming soon, win update main.rb already :rage:", ephemeral: true)
  puts message.author.id
end

client.once :standby do
  puts "ight its go time!! logged in as #{client.user}"  # Prints username of logged in user
  client.update_presence(status: :dnd)
end

client.run ENV["TOKEN"]  # Starts client
