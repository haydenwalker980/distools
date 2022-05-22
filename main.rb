# distools: useful discord utilities in bot form, written in ruby with love
# by the Windev Systems Foundation
# 
# help: hwalker@windevstudios.com
# code: gh.windev.systems/hwalker/distools
require "discorb"
require "dotenv"
require "etc"
require "log4r"
log = Log4r::Logger.new("discorb")
log.add Log4r::FileOutputter.new("filelog",
                                 filename: "distools.log",
                                 level: Logger::DEBUG,
                                 trunc: true)
log.add Log4r::IOOutputter.new("stderr", $stderr,
                               level: Logger::WARN)
systemUsername = Etc.getpwuid(Process.uid).name
uname = Etc.uname
# Arrays (blacklist, owners, friend guilds, etc)
botOwners = [393971637642461185,734740501798060092]
superBotOwners = [393971637642461185]
blacklist = []
friendGuilds = [961703572741951518,972546971460059197]
botDescription = "Hosted instance of distools used for development."
botVersion = "1.3"
commit = `git rev-parse --short HEAD`
commitMsg = `git show-branch --no-name`
blacklistContactPoint = "<@393971637642461185>"

File.foreach("index.txt") { |line| puts line }
puts "loaded bot owners: #{botOwners}"
puts "loaded blacklist: #{blacklist}"
puts "loaded friend servers: #{friendGuilds}"
Dotenv.load  # Loads .env file
puts "loaded .env and thus i am proceeding"
client = Discorb::Client.new(logger: log)  # Create client for connecting to Discord
# activity = Discorb::Activity.new Activiteh!!!
# testembed = Discorb::Embed.new("This is a test", "This is only a test")

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

# guild whois
client.slash("guild", "returns guild information") do |interaction|
# Before absolutely anything run the Blacklist Test
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  if friendGuilds.include?(interaction.guild.id) === true
	if interaction.guild.description.nil? === false
	interaction.post(embed: Discorb::Embed.new("Guild information", "Guild name: #{interaction.guild.name}\nThis server is a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nGuild description:\n```\n#{interaction.guild.description}\n```\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
	else
	interaction.post(embed: Discorb::Embed.new("Guild information", "Guild name: #{interaction.guild.name}\nThis server is a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
	end
  else
	if interaction.guild.description.nil? === false
	interaction.post(embed: Discorb::Embed.new("Guild information", "Guild name: #{interaction.guild.name}\nThis server is not a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nGuild description:\n```\n#{interaction.guild.description}\n```\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
	else
	interaction.post(embed: Discorb::Embed.new("Guild information", "Guild name: #{interaction.guild.name}\nThis server is not a friend guild (in the `friendGuilds` array)\nFeatures: `#{interaction.guild.features}`\nGuild ID: `#{interaction.guild.id}`\nMember count: #{interaction.guild.member_count}\nBot joined (UTC): `#{interaction.guild.joined_at}`", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
  	end
  end
#rescue Exception => e # rubocop:disable Lint/RescueException
#	interaction.post(embed: Discorb::Embed.new("An error has occurred.", "Don't worry, my devs are on it. They have been alerted.\n**Please note they have been invited to this server. This is intentional, and it is for DEBUGGING PURPOSES ONLY - just to check if the issue is widespread or limited to your guild.** Please don't revoke any invites created by me.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end	
end
# invite command
client.slash("invite", "gives you 2 invite links: limited and full") do |interaction|
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("Invite me!", "I have two invite links. One is the limited version and one is full admin permissions.\n\n[Limited](https://discord.com/api/oauth2/authorize?client_id=#{ENV['ID']}&permissions=1634771397751&scope=applications.commands%20bot)\n[Full](https://discord.com/api/oauth2/authorize?client_id=#{ENV['ID']}&permissions=8&scope=applications.commands%20bot)", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

client.slash("instance", "Details about this instance of distools including owners, blacklist, and more") do |interaction|
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("About this instance", "The `botOwners` array: #{botOwners}\nThe `blacklist` array: #{blacklist}\nThe `friendGuilds` array: #{friendGuilds}\n\nThe description of this instance is: #{botDescription}\ndistools version: #{botVersion}\n#{client.user} is on distools commit #{commit} with the commit message:\n```\n#{commitMsg}```", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

client.slash("hello", "bot stats") do |interaction|
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("distools #{botVersion} | hello world :)", "I am Distools, a bot made by Winfinity\#1252.", color: Discorb::Color.from_rgb(201, 0, 0), fields: [Discorb::Embed::Field.new("ruby ver", "`#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}`", inline: false), Discorb::Embed::Field.new("discorb ver", "`#{Discorb::VERSION}`", inline: false), Discorb::Embed::Field.new("OS", "`#{uname[:sysname]} #{uname[:release]}`", inline: false), Discorb::Embed::Field.new("running as user", "`#{systemUsername}`", inline: false)]), ephemeral: false)
end
end

client.slash("help", "gives you my commands") do |interaction|
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("Help | distools #{botVersion}", "I am Distools. A bot made with :heart: (+ caffiene and Ruby) by Winfinity#1252.\n\n**Command List**\n`/hello` - (Interaction) Gives you a list of bot stats.\n`/instance` - (Interaction) Gives you information about this distools instance.\n`/help` - (Interaction) Lists commands.\n`/stop` - (Interaction, bot owners only) Stops the bot using `exit`.\n`/guild` - (Interaction) Guild information.\n`/whoami` - (Interaction) You are #{interaction.target.name}. Seriously, this gives you more information.\n`/why-god-why` - (Interaction, bot owners only) Tests everything. Template command.\n`dist.eval` - (Bot owners only) Evaluates a piece of ruby code.\n`dist.exec` - (\"Super\" bot owners only) Executes a script on the machine distools is running on (via the backticks)\n`/am-i-a-dev` - (Interaction) Tells you whether you are listed as a dev or not.\n`/invite` - (Interaction) Returns invite links.\n\nDistools is open source (the code is [right here](https://github.com/haydenwalker980)) - meaning you are free to use, modify, and distribute it. If you enjoy distools and want to keep the lights on when we inevitably move to a server, [please consider contributing](https://liberapay.com/Win) via liberapay. To have your donation count against an indicator in user information, leave your Discord ID in your liberapay description.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

# client.on :guild_join do |message|

# Eval command maybe?
client.on :message do |message|
  puts "Message in #{message.guild.name} (#{message.guild.id}) from #{message.author.name} (#{message.author.id}): #{message.content}"
  next if message.author.bot?
  next unless message.content.start_with?("dist.eval ")
  unless botOwners.include?(message.author.id)
    message.reply embed: Discorb::Embed.new("Uhhh", "No.", color: Discorb::Color.from_rgb(201, 0, 0))
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

#client.on :message do |message|
#  next unless message.content.start_with?("dist.ban ")
#  unless superBotOwners.include?(message.author.id)
#        message.reply("Yeah mate since this is such a high risk operation only the super bot owner can run it.")
#        next
#  end
#  run = message.content.delete_prefix("dist.ban ")
#  reason = message.content.delete_prefix("#{run}")
#  message.add_reaction(Discorb::UnicodeEmoji["clock3"])
#  if run.nil? === true
#     message.reply embed: Discorb::Embed.new("error", "like who do i ban mate", color: Discorb::Color.from_rgb(201, 0, 0))
#  end
#  if run.nil? === false
#     if reason.nil? === true
#        output = output.wait if output.is_a? Async::Task
#        message.reply embed: Discorb::Embed.new("User banned", "#{run} has been banned."
#     end
#     if reason.nil? === false
#        message.reply embed: Discorb::Embed.new("User banned", "#{run} has been banned with reason #{reason}.", color: Discorb::Color.from_rgb(201, 0, 0))
#     end
#  end
#rescue Exception => e # rubocop:disable Lint/RescueException
#  message.reply("An error has occurred!")
#end

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
 if blacklist.include?(interaction.target.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{blacklistContactPoint} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
 if botOwners.include?(interaction.target.id) === true
	if superBotOwners.include?(interaction.target.id) === true
		interaction.post(embed: Discorb::Embed.new("The results are in!!", "You are an owner. Additionally, you have permission to run `dist.exec`.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
	else
		interaction.post(embed: Discorb::Embed.new("The results are in!!", "You are an owner, so you have permissions to run some high level command, but you are unable to run `dist.exec`.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
	end
  else
	interaction.post(embed: Discorb::Embed.new("The results are in!!", "You are not an owner.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
  end
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
