module BotPerms
	# Distools permissions configuration.
	# Don't run this file directly, run main.rb (or bin/start)
	# Permissions structure inspired by (or maybe copied from I haven't looked) DTel.
	#########################################################################################################
	# Dev team											 	#
	BOTOWNERS = [393971637642461185,734740501798060092,695090289685299280]				 	#
	# Me (or you) and alts. Used for dist.exec.							 	#
	# Give this to only you - anyone with an ID in this list can run Bash commands on your machine!! 	#
	EXECUSERS = [393971637642461185]								 	#
	# The blacklist, enter User IDs here. Might be migrated to the database soon. Idfk.		 	#
	BLACKLISTED = [901917112161955930,980690782199640074]						 	#
	# Owner, but less permissive									 	#
	BOTMGMT = []											 	#
	# Customer Support team										 	#
	BOTCST = []											 	#
	# Supervisors to the bot staff :)								 	#
	BOTSUPERVISORS = []										 	#
	# Users with permission to run commands preceding with "dist.beta.", essentially the Beta Testers	#
	# Put you and your alts in here as well as experienced users :)						#
	BETATESTERS = [393971637642461185]									#
	TUSERS = [393971637642461185,734740501798060092,877600052334452789]					#
	#########################################################################################################
end
