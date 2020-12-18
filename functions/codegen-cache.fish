function codegen-cache --description "Cache the output of a command until the executable is updated"
	if [ "$argv[1]" = "-h" ]
		echo "codegen-cache"
		echo "Cache the output of a command until the executable is updated"
		echo ""
		echo "USAGE:"
		echo -e "\tcodegen-cache [FLAGS] <COMMAND>"
		echo ""
		echo "FLAGS:"
		echo -e "\t-e\tErase the current cache entry and rerun COMMAND"
		echo ""
		echo "(c) 2020 Eugene Babichenko https://github.com/eugene-babichenko/fish-codegen-cache"
		return
	end

	if [ "$argv[1]" = "-e" ]
		set erase
		set -e argv[1]
	end

	# Cache key is the hash of the whole command and the last changed date
	set hash (echo -n $argv[1..-1] | sha1sum | cut -d ' ' -f1)
	set key __fish_codegen_cache_$hash

	# Erase the cache entry and re-generate the code if requested
	set -q erase; and set -e $key

	# Only if the command was changed or the executable was updated generate the code once again
	set exec_last_updated (stat -c %Y (which $argv[1]))
	set command_data $$key
	if set -q $key
		if test $exec_last_updated -le $command_data[2]
			echo -e $command_data[3]
			return
		end
	end

	# The output of a command is read as a list, so we need to join it back.
	set output (string join '\n' ($argv[1..-1]))
	set -U $key "$argv[1..-1]" $exec_last_updated $output
	echo -e $output
end
