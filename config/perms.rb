module BotPerms
	# Distools permissions configuration.
	# Don't run this file directly, run main.rb (or bin/start)
	# Permissions structure inspired by (or maybe copied from I haven't looked) DTel.
	##################################################################################################
	# Dev team											 #
	BOTOWNERS = [393971637642461185,734740501798060092,695090289685299280]						 #
	# Me (or you) and alts. Used for dist.exec.							 #
	# Give this to only you - anyone with an ID in this list can run Bash commands on your machine!! #
	EXECUSERS = [393971637642461185]								 #
	# The blacklist, enter User IDs here. Might be migrated to the database soon. Idfk.		 #
	BLACKLISTED = []											 #
	# Owner, but less permissive									 #
	BOTMGMT = []										 #
	# Customer Support team										 #
	BOTCST = []											 #
	# Supervisors to the bot staff :)								 #
	BOTSUPERVISORS = []										 #
	##################################################################################################
end
