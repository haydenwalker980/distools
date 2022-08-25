# This file is part of Distools, an open-source Discord bot written with Discorb.
# Copyright (C) 2022 Hayden Walker.
#
# This program is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) 
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "discorb"
require "dotenv"
require "etc"
require "log4r"
require "mongo"
require_relative "config/perms"
require_relative "config/mongo"
require_relative "config/strings"
database = Mongo::Client.new(DataConn::URI)
puts "(Maybe) connected to Mongo."
log = Log4r::Logger.new("discorb")
log.add Log4r::FileOutputter.new("filelog",
                                 filename: "distools.log",
                                 level: Logger::DEBUG,
                                 trunc: true)
log.add Log4r::IOOutputter.new("stderr", $stderr,
                               level: Logger::WARN)
systemUsername = Etc.getpwuid(Process.uid).name
uname = Etc.uname
friendGuilds = [961703572741951518,972546971460059197]
botVersion = "2.1 RW"
commit = `git rev-parse --short HEAD`
commitMsg = `git show-branch --no-name`

File.foreach("index.txt") { |line| puts line }
puts "loaded bot owners: #{BotPerms::BOTOWNERS}"
puts "loaded blacklist: #{BotPerms::BLACKLISTED}"
puts "loaded friend guilds: #{friendGuilds}"
Dotenv.load  # Loads .env file
puts "loaded .env and thus i am proceeding"
intents = Discorb::Intents.new(members: true, message_content: true, presences: true)
client = Discorb::Client.new(logger: log, intents: intents)  # Create client for connecting to Discord
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
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
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
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("Invite me!", "I have two invite links. One is the limited version and one is full admin permissions.\n\n[Limited](https://discord.com/api/oauth2/authorize?client_id=#{ENV['ID']}&permissions=1634771397751&scope=applications.commands%20bot)\n[Full](https://discord.com/api/oauth2/authorize?client_id=#{ENV['ID']}&permissions=8&scope=applications.commands%20bot)", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

# best interaction ever
client.slash("garment", "garment") do |interaction|
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post("this is a certified not garment moment", embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)))
 else
	interaction.post("garment", embed: Discorb::Embed.new("garment", "garment", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 end
end
client.slash("instance", "Details about this instance of distools including owners, blacklist, and more") do |interaction|
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("About this instance", "The description of this instance is: #{DistoolsStr::INSTDESCRIPTION}\ndistools version: #{botVersion}\n#{client.user} is on distools commit #{commit} with the commit message:\n```\n#{commitMsg}```", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

client.slash("hello", "bot stats") do |interaction|
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("distools #{botVersion} | hello world :)", "I am Distools, a bot made by Winfinity\#1252.", color: Discorb::Color.from_rgb(201, 0, 0), fields: [Discorb::Embed::Field.new("ruby ver", "`#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}`", inline: false), Discorb::Embed::Field.new("discorb ver", "`#{Discorb::VERSION}`", inline: false), Discorb::Embed::Field.new("OS", "`#{uname[:sysname]} #{uname[:release]}`", inline: false), Discorb::Embed::Field.new("running as user", "`#{systemUsername}`", inline: false)]), ephemeral: false)
end
end

client.slash("help", "gives you my commands") do |interaction|
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
  interaction.post(embed: Discorb::Embed.new("Help | distools #{botVersion}", "I am Distools. A bot made with :heart: (+ caffiene and Ruby) by Winfinity#1252.\n\n**Command List**\n`/hello` - (Interaction) Gives you a list of bot stats.\n`/instance` - (Interaction) Gives you information about this distools instance.\n`/help` - (Interaction) Lists commands.\n`/stop` - (Interaction, bot owners only) Stops the bot using `exit`.\n`/guild` - (Interaction) Guild information.\n`/whoami` - (Interaction) You are #{interaction.user.name}. Seriously, this gives you more information.\n`/why-god-why` - (Interaction, bot owners only) Tests everything. Template command.\n`dist.eval` - (Bot owners only) Evaluates a piece of ruby code.\n`dist.exec` - (\"Super\" bot owners only) Executes a script on the machine distools is running on (via the backticks)\n`/am-i-a-dev` - (Interaction) Tells you whether you are listed as a dev or not.\n`/invite` - (Interaction) Returns invite links.\n\nDistools is open source (the code is [right here](https://github.com/haydenwalker980)) - meaning you are free to use, modify, and distribute it. If you enjoy distools and want to keep the lights on when we inevitably move to a server, [please consider contributing](https://liberapay.com/Win) via liberapay. To have your donation count against an indicator in user information, leave your Discord ID in your liberapay description.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end

# client.on :guild_join do |message|

# Eval command maybe?
client.on :message do |message|
#  puts "Message in #{message.guild.name} (#{message.guild.id}) from #{message.author.name} (#{message.author.id}): #{message.content}"
  next if message.author.bot?
  next unless message.content.start_with?("dist.eval ")
  unless BotPerms::BOTOWNERS.include?(message.author.id)
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
  message.reply embed: Discorb::Embed.new("Do you smell something burning?", "An error occurred! Something may have been wrong with your code snippet.\n```rb\n#{e.full_message(highlight: false)[...1990]}\n```",
                                          color: Discorb::Color[:red])
end

client.on :message do |message|
  next if message.author.bot?
  next unless message.content.start_with?("dist.beta.DocTest")
  unless BotPerms::BETATESTERS.include?(message.author.id)
     message.reply embed: Discorb::Embed.new("Error", "you are not a `BotPerms::BETATESTER`. if you know Ruby and Mongo, contact #{DistoolsStr::BCP} in order to become one of the `BotPerms::BETATESTERS`.", color: Discorb::Color.from_rgb(201, 0, 0))
     next
  end
  
  
  message.reply embed: Discorb::Embed.new("Fun, an unfinished command!", "you are a `BotPerms::BETATESTER` but like this command is so unfinished that it would likely make the bot commit suicide if you ran this command so I won't let you run it. it will be finished soon as a functioning economy is one of my top priorities for this bot.", color: Discorb::Color.from_rgb(201, 0, 0))
end

client.on :message do |message|
  next unless message.content.start_with?("dist.exec ")
  unless BotPerms::EXECUSERS.include?(message.author.id)
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
  interaction.post(embed: Discorb::Embed.new("User information for #{interaction.user.name}", "User ID: #{interaction.user.id}\nSignup time: #{interaction.user.created_at}\nUser flags: #{interaction.user.flag}", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end

# Gonna see if this works. Ctrl C does not seem like a good way to end a bot so I
# think I will gracefully stop it
client.slash("stop", "[owner only] shutting down") do |interaction|
  if BotPerms::BOTOWNERS.include?(interaction.user.id) === true
	puts "peaceful shutdown initiated"
	interaction.post("ok, shutting down, goodbye :sleeping:", ephemeral: false)
	exit
  else
	interaction.post("what the hell goes through someones mind to make you think you can run this command. you aint the owner and it says owner only", ephemeral: true)
  end
end

client.slash("am-i-a-dev", "tells you whether the bot thinks you are a dev or not") do |interaction|
 if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
	interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
 else
 if BotPerms::BOTOWNERS.include?(interaction.user.id) === true
	if BotPerms::EXECUSERS.include?(interaction.user.id) === true
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
  if BotPerms::BOTOWNERS.include?(interaction.user.id) === true
	puts "Oh dear god it's a stress test. We're all gonna die."
	interaction.post("*insert :hollow: here*", embed: Discorb::Embed.new("embed test :hollow:", "This is only a test"), ephemeral: false)
  else
	interaction.post("no", ephemeral: false)
  end
end

client.slash("rift", "Open a rift to another server distools is in via your DMs [Owner only]", {
	"server" => {
	 required: true,
	 type: :string,
	 description: "The server to open a rift to"
	}
}) do |interaction, server|
if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
  interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
else
  interaction.post(embed: Discorb::Embed.new("Work-in-Progress", "This command is a work in progress. I am yet to figure out how to get an active log of messages in another server. Even then, this command will be owner only when it's out.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end
client.slash("say", "Get me to say something", {
	"text" => {
	  required: true,
	  type: :string,
	  description: "what I say"
	}
}) do |interaction, text|
if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
  interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
else
 if text.include?("@here")
   interaction.post("Hey wait a minute thats not nice of you", ephemeral: false)
 elsif text.include?("@everyone")
   interaction.post("I cannot have you waking someone up sorry bud", ephemeral: false)
 else
  interaction.post("#{text}\n\n- <@#{interaction.user.id}>", ephemeral: false)
 end
end
end

client.slash("timeout", "Timeout someone", {
	"target" => {
	 required: true,
	 type: :user,
	 description: "The person to timeout."
	},
        "time" => {
         required: true,
         type: :int,
         description: "The amount of time (IN SECONDS) to time them out for"
        },
	"reason" => {
	 required: false,
	 type: :string,
	 description: "Why are you doing this to them"
	}
}) do |interaction, target, time, reason|
if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
  interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
elsif interaction.user.permissions.mute_members? === true
 if reason
  timetoTO = Time.new + time.to_i
  target.timeout(timetoTO, reason: "Timed out by #{interaction.user.to_s} for committing the sin of #{reason}")
  interaction.post(embed: Discorb::Embed.new("someones been bad :(", "I successfully timed out #{target.to_s} for committing the sin of \"#{reason}\"", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: true)
 else
  target.timeout(timetoTO, reason: "Timed out by #{interaction.user.to_s}, but they didn't say why")
  interaction.post(embed: Discorb::Embed.new("someones been bad :(", "I just timed out #{target.to_s} for absolutely no reason.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: true)
 end
else
  interaction.post(embed: Discorb::Embed.new("Access denied.", "You do not have the permissions required by this command (**Timeout Members**), please don't try to do that", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
end
end
client.slash("tsay", "Say something without attributing it to you. For...reasons, only works for privileged users", {
	"text" => {
	 required: true,
	 type: :str,
	 description: "What do I say"
	}
}) do |interaction, text|
if BotPerms::BLACKLISTED.include?(interaction.user.id) === true
  interaction.post(embed: Discorb::Embed.new("A critical exception has occurred.", "The command returned the following error:\nYou have been blacklisted from distools. Please contact #{DistoolsStr::BCP} if you believe this was in error.", color: Discorb::Color.from_rgb(201, 0, 0)), ephemeral: false)
else
if BotPerms::TUSERS.include?(interaction.user.id) === true
 if text.include?("@here")
   interaction.post("Hey wait a minute thats not nice of you", ephemeral: false)
 elsif text.include?("@everyone")
   interaction.post("I cannot have you waking someone up sorry bud", ephemeral: false)
 else
   interaction.post("#{text}", ephemeral: false)
 end
 else
   interaction.post("Hey buddy you aren't listed as someone that can use this command but you tried to use this command and that's not exactly cool please don't do that again", ephemeral: true)
 end
end
end

# reboot cmd
client.slash("reboot", "Restart this horrible bot which in turn loads new commits and changes without much disruption") do |interaction|
if BotPerms::BOTOWNERS.include?(interaction.user.id) === true
	interaction.post("Ok be right back")
# This is broken, needs a fix
#	client.update_presence(Discorb::Activity.new("and undergoing process reboot, be patient :|", :playing), status: :idle)
	# Replace the current distools process with an entirely new one
	Kernel.exec("bin/start")
else
	interaction.post("I refuse.", ephemeral: false)
end
end

client.slash("brainpower", "LET THE BASS KICK") do |interaction|
interaction.post("O-oooooooooo AAAAE-A-A-I-A-U- JO-oooooooooooo AAE-O-A-A-U-U-A- E-eee-ee-eee AAAAE-A-E-I-E-A- JO-ooo-oo-oo-oo EEEEO-A-AAA-AAAA")
end


client.once :standby do
  puts "ight its go time!! logged in as #{client.user}"  # Prints username of logged in user
  client.update_presence(status: :dnd)
  puts "guilds: Dictionary: #{client.guilds}"
end

client.run ENV["TOKEN"]  # Starts client
