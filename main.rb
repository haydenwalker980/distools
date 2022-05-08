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
# Arrays (blacklist, owners, friend guilds, etc)
botOwners = [393971637642461185,734740501798060092]
superBotOwners = [393971637642461185]
blacklist = []
friendGuilds = [961703572741951518,972546971460059197]
botDescription = "Hosted instance of distools used for development."
botVersion = "1.2"
commit = `git rev-parse --short HEAD`
commitMsg = `git show-branch --no-name`

File.foreach("index.txt") { |line| puts line }
puts "loaded bot owners: #{botOwners}"
puts "loaded blacklist: #{blacklist}"
puts "loaded friend servers: #{friendGuilds}"
Dotenv.load  # Loads .env file
puts "loaded .env and thus i am proceeding"
client = Discorb::Client.new  # Create client for connecting to Discord
# activity = Discorb::Activity.new # Activiteh!!!
testembed = Discorb::Embed.new("This is a test", "This is only a test", footer: ":hollow:")

%i[standby guild_join guild_leave ready channel_delete].each do |event|
  client.on event do
    client.update_presence(
      Discorb::Activity.new(
        "#{client.guilds.length} guilds, Ruby #{RUBY_VERSION} // Discorb #{Discorb::VERSION}", :watching
      ),
      status: :dnd
    )
  end
end

client.on :ready do
  client.update_presence(status: :dnd)
end

# Application commands
#client.user_command("hello") do |interaction, user|
#  interaction.post("`world`\n\n`distools` by Winfinity\#1252\n`you are: #{user.name}`\n`ruby ver: #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}`\n`discorb ver: #{Discorb::VERSION}`\n`OS: #{uname[:sysname]} #{uname[:release]}`\n`running as: #{systemUsername}`", embed: Discorb::Embed.new())
#end

client.slash("guild", "returns guild information") do |interaction|
  if friendGuilds.include?(interaction.guild.id) === true
	interaction.post(embed: Discorb::Embed.new("Guild information", "This server is a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nGuild description:\n```\n#{interaction.guild.description}\n```\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
  else
	interaction.post(embed: Discorb::Embed.new("Guild information", "This server is not a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nGuild description:\n```\n#{interaction.guild.description}\n```\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
  end
end
# invite command
client.slash("invite", "gives you 2 invite links: limited and full") do |interaction|
  interaction.post(embed: Discorb::Embed.new("Invite me!", "I have two invite links. One is the limited version and one is full admin permissions.\n\n[Limited](https://discord.com/api/oauth2/authorize?client_id=972452053697843240&permissions=1634771397751&scope=applications.commands%20bot)\n[Full](https://discord.com/api/oauth2/authorize?client_id=972452053697843240&permissions=8&scope=applications.commands%20bot)", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end

client.slash("instance", "Details about this instance of distools including owners, blacklist, and more") do |interaction|
  interaction.post(embed: Discorb::Embed.new("About this instance", "The `botOwners` array: #{botOwners}\nThe `blacklist` array: #{blacklist}\nThe `friendGuilds` array: #{friendGuilds}\n\nThe description of this instance is: #{botDescription}\ndistools version: #{botVersion}\n#{client.user} is on distools commit #{commit} with the commit message:\n```\n#{commitMsg}```", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end

client.slash("hello", "bot stats") do |interaction|
  interaction.post(embed: Discorb::Embed.new("distools #{botVersion} | hello world :)", "I am Distools, a bot made by Winfinity\#1252.", color: Discorb::Color.from_rgb(201, 0, 0), fields: [Discorb::Embed::Field.new("ruby ver", "`#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}`", inline: false), Discorb::Embed::Field.new("discorb ver", "`#{Discorb::VERSION}`", inline: false), Discorb::Embed::Field.new("OS", "`#{uname[:sysname]} #{uname[:release]}`", inline: false), Discorb::Embed::Field.new("running as user", "`#{systemUsername}`", inline: false)]), ephemeral: false)
end

client.slash("help", "gives you my commands") do |interaction|
  interaction.post(embed: Discorb::Embed.new("Help | distools #{botVersion}", "I am Distools. A bot made with :heart: (+ caffiene and Ruby) by Winfinity#1252.\n\n**Command List**\n`/hello` - (Interaction) Gives you a list of bot stats.\n`/instance` - (Interaction) Gives you information about this distools instance.\n`/help` - (Interaction) Lists commands.\n`/stop` - (Interaction, bot owners only) Stops the bot using `exit`.\n`/guild` - (Interaction) Guild information.\n`/whoami` - (Interaction) You are #{interaction.target.name}. Seriously, this gives you more information.\n`/why-god-why` - (Interaction, bot owners only) Tests everything. Template command.\n`dist.eval` - (Bot owners only) Evaluates a piece of ruby code.\n`dist.exec` - (\"Super\" bot owners only) Executes a script on the machine distools is running on (via the backticks)\n`/am-i-a-dev` - (Interaction) Tells you whether you are listed as a dev or not.\n`/invite` - (Interaction) Returns invite links.\n\nDistools is open source (the code is [right here](https://github.com/haydenwalker980)) - meaning you are free to use, modify, and distribute it. If you enjoy distools and want to keep the lights on when we inevitably move to a server, [please consider contributing](https://liberapay.com/Win) via liberapay. To have your donation count against an indicator in user information, leave your Discord ID in your liberapay description.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end

# client.on :guild_join do |message|

# Eval command maybe?
client.on :message do |message|
  next if message.author.bot?
  next unless message.content.start_with?("dist.eval ")

  unless botOwners.include?(message.author.id)
    message.reply("No. Just no.")
    next
  end

  code = message.content.delete_prefix("dist.eval ").delete_prefix("```rb").delete_suffix("```")
  message.add_reaction(Discorb::UnicodeEmoji["clock3"])
  res = eval("Async { |task| #{code} }.wait", binding, __FILE__, __LINE__) # rubocop:disable Security/Eval
  message.remove_reaction(Discorb::UnicodeEmoji["clock3"])
  message.add_reaction(Discorb::UnicodeEmoji["white_check_mark"])
  unless res.nil?
    res = res.wait if res.is_a? Async::Task
    message.channel.post("```rb\n#{res.inspect[...1990]}\n```")
  end
rescue Exception => e # rubocop:disable Lint/RescueException
  message.reply embed: Discorb::Embed.new("Error!", "```rb\n#{e.full_message(highlight: false)[...1990]}\n```",
                                          color: Discorb::Color[:red])
end

client.on :message do |message|
  next unless message.content.start_with?("dist.exec ")
  unless superBotOwners.include?(message.author.id)
        message.reply("Yeah mate since this is such a high risk operation only the super bot owner can run it.")
        next
  end

  run = message.content.delete_prefix("dist.exec ")
  message.add_reaction(Discorb::UnicodeEmoji["clock3"])
  output = `#{run}`
  unless output.nil?
     output = output.wait if output.is_a? Async::Task
     message.reply embed: Discorb::Embed.new("Output of command #{run}", "```\n#{systemUsername} $ #{run}\n#{output}\n```", color: Discorb::Color.from_rgb(201, 0, 0))
  end
rescue Exception => e # rubocop:disable Lint/RescueException
  message.reply("uh oh something went wrong check ya logs")
end

client.slash("whoami", "information about you") do |interaction|
  interaction.post(embed: Discorb::Embed.new("User information for #{interaction.target.name}", "User ID: #{interaction.target.id}\nSignup time: #{interaction.target.created_at}\nUser flags: #{interaction.target.flag}", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end

# Gonna see if this works. Ctrl C does not seem like a good way to end a bot so I
# think I will gracefully stop it
client.slash("stop", "[owner only] shutting down") do |interaction|
  if botOwners.include?(interaction.target.id) === true
	puts "peaceful shutdown initiated"
	interaction.post("ok, shutting down, goodbye :sleeping:", ephemeral: false)
	exit
  else
	interaction.post("what the hell goes through someones mind to make you think you can run this command. you aint the owner and it says owner only", ephemeral: true)
  end
end

client.slash("am-i-a-dev", "tells you whether the bot thinks you are a dev or not") do |interaction|
  if botOwners.include?(interaction.target.id) === true
	interaction.post("certified owner moment", ephemeral: false)
  else
	interaction.post("certified not owner moment", ephemeral: false)
  end
end

client.slash("why-god-why", "[owner only] tests ABSOLUTELY EVERYTHING. could serve as a template command") do |interaction|
  if botOwners.include?(interaction.target.id) === true
	puts "Oh dear god it's a stress test. We're all gonna die."
	interaction.post("*insert :hollow: here*", embed: Discorb::Embed.new("embed test :hollow:", "This is only a test"), ephemeral: false)
  else
	interaction.post("no", ephemeral: false)
  end
end

client.once :standby do
  puts "ight its go time!! logged in as #{client.user}"  # Prints username of logged in user
  client.update_presence(status: :dnd)
end

client.run ENV["TOKEN"]  # Starts client
