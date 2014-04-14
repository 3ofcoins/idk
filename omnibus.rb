# https://github.com/opscode/omnibus-ruby/commit/c01f85515bb3028609c22f99813e66562fb29b84
# not yet released
Omnibus::HealthCheck::MAC_WHITELIST_LIBS << /CoreServices/
Omnibus::HealthCheck::MAC_WHITELIST_LIBS << /libicucore/
