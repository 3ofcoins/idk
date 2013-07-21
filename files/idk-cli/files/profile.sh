# Prepend IDK to $PATH, even if it's already in the middle. It is
# somewhat intrusive, but rvm insists on prepending itself, so we use
# this script as its `after_use` hook to trick it into restoring the
# order.
export PATH="/opt/idk/bin:`echo "$PATH" | sed s,/opt/idk/bin:,,`"

# IDK-CLI reads this variable to know whether to suggest adding the
# script to profile.
export idk_profile_loaded=true
