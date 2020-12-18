function codegen-cache --description "Cache the output of a command until the executable is updated"
	if [ "$argv[1]" = "-h" ]
		echo "codegen-cache"
		echo "Cache the output of a command until the executable is updated"
		echo ""
		echo "USAGE:"
		echo -e "\tcodegen-cache [FLAGS] [COMMAND]"
		echo ""
		echo "FLAGS:"
		echo -e "\t-l\t\tList cache entries. Their numbers can be used for erasing them."
		echo -e "\t-e <NUMBER>\tErase the cache entry with NUMBER."
		echo ""
		echo "(c) 2020 Eugene Babichenko https://github.com/eugene-babichenko/fish-codegen-cache"
		return
	end

	if [ "$argv[1]" = "-l" ]
		set i 1
		echo -e "No.\tCommand"
		for hash in $__fish_codegen_cache_entries
			set key __fish_codegen_cache_$hash
			set command_data $$key
			echo -e "$i\t$command_data[1]"
			set i (math $i + 1)
		end
		return
	end

	if [ "$argv[1]" = "-e" ]
		if ! set -q $argv[2]
			echo "You must provide a number of an entry to remove!"
			return 1
		end
		if ! set -q __fish_codegen_cache_entries[$argv[2]]
			echo "Cache entry not found!"
			return 1
		end
		set -e $__fish_codegen_cache_entries[$argv[2]]
		set -e __fish_codegen_cache_entries[$argv[2]]
		return
	end

	# Cache key is the hash of the whole command and the last changed date
	set hash (echo -n $argv[1..-1] | sha1sum | cut -d ' ' -f1)
	set key __fish_codegen_cache_$hash

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
        set -Ua __fish_codegen_cache_entries $hash
	echo -e $output
end
