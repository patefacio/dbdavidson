#/bin/sh

file=$1

################################################################################
# Search up direcoties from `start_dir` looking for `mix.exs`
################################################################################
find_mix ()
{
    local start_dir=$1
    cd $start_dir
    local project_dir=
    while [ $PWD != "/" ]; do test -e mix.exs && { project_dir=`pwd`; break; }; cd .. ; done

    if [ "$project_dir" != "" ]; then
        echo $project_dir
    else
        echo "Unable to find elixir project dir from ${`pwd`}"
        exit 1
    fi
}

################################################################################
# If file arg passed, start in folder of file, otherwise start at current dir
################################################################################
if [ -z $file ]; then
    START_DIR=`pwd`
else
    file=$(realpath "$file")
    START_DIR=$(dirname "$file")
    if [ ! -d "$START_DIR" ]; then
        echo "Invalid directory specified ${START_DIR}"
        exit 1
    fi
fi

PROJECT_DIR=$(find_mix "$START_DIR")

pushd $PROJECT_DIR > /dev/null

if [ -z $file ]; then
    echo "Formatting elixir project: ${PROJECT_DIR}"
    mix format
else
    echo "Formatting elixir file \"`basename $file`\" from: ${PROJECT_DIR}"
    mix format $file
fi
popd > /dev/null
