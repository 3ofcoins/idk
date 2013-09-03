_basedir = File.expand_path(File.dirname(__FILE__))
file_cache_path "/var/local/idk/cache/chef-solo"
cookbook_path [ "#{_basedir}/site-cookbooks", "#{_basedir}/cookbooks" ]
verbose_logging false
