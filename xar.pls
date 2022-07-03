#!/usr/bin/env polaris
usage: "xar [options] <file>"

options {
    "-v" "--verbose" as verbose
    # Named arguments are still a bit broken with defaults
    "-m" "--main" (main) as mainDefault = "main" : "Set the entrypoint to be run when executing the archive"
    "-z" "--zip-option" (*) as zipOptions : "Options to pass to 'zip'"
    "-o" "--output" (output) as outputDefault = "a.out"
}
ensure("zip")
ensure("unzip")

# Ugghhh
if main == null then
    main := mainDefault
else {}

if output == null then
    output := outputDefault
else {}


let files = match getArgv() {
    # Working around a bug with getArgv().
    # Ideally, arguments should be treated like options anyway
    (_ : _ : file : files) -> [file] ~ files
    _ -> fail("Missing file arguments. Use xar --help for more information")
}

if verbose then {
    print("Creating archive from files: " ~ toString(files))
}else {

}

let header = "#!/usr/bin/bash
id=$RANDOM
mkdir -p /tmp/xar/$id
lines=$(cat $0 | wc -l)
tail -n $(($lines - 9)) $0 > /tmp/xar/$id/xar_temp.zip
unzip -qd /tmp/xar/$id /tmp/xar/$id/xar_temp.zip
export XAR_ROOT=/tmp/xar/$id
/tmp/xar/$id/" ~ main ~ " $@
exec rm -r /tmp/xar/$id
"

!zip "-r" "xar_temp.zip" files

# TODO: Doing this in bash right now, since polaris does not have file redirects yet 
# and we should avoid loading the entire zip file into memory.
!bash "-c" ("echo '" ~ header ~ "' | cat - xar_temp.zip > " ~ output)
!rm "xar_temp.zip"

!chmod "+x" "a.out"
