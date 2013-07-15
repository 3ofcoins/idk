if [ "x$idk_profile_loaded" = "x" ] ; then
    if ! echo "$PATH" | grep -q '/opt/idk/bin' ; then
        export PATH="/opt/idk/bin:$PATH"
    fi
    for command in berks chef-apply chef-shell chef-solo knife ohai shef ; do
        alias $command="idk exec $command"
    done
    export idk_profile_loaded=true
fi
