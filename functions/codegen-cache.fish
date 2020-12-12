function codegen-cache --description "Cache the output of a command until the executable is updated"
	# Cache key is the hash of the whole command and the last changed date
	set hash (echo -n $argv[1..-1] (stat -c %Y (which $argv[1])) | sha1sum | cut -d ' ' -f1)
	set key __fish_codegen_cache_$hash
	# If the command was changed or the executable was updated generate the code once again
	set -q $key; or set -U $key (echo $argv[1..-1] | source)
	# Output of the command in the previous step is considered a list. Join it back to a string.
	string join \n $$key
end
