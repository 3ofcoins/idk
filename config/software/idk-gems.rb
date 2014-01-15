name "idk-gems"

dependency "ruby"
dependency "rubygems"

dependency 'rake-gem'
dependency 'berkshelf'
dependency 'chef-gem'

gems = {
  'chefspec' => '3.1.4',
  'foodcritic' => '3.0.3',
  'test-kitchen' => '1.1.1',
  'kitchen-vagrant' => '0.14.0',
  'strainer' => '3.3.0',

  'omnibus' => '1.3.0',
  'vendorificator' => '0.5.0',
  'mina' => '0.3.0',
  'capistrano' => '3.0.1',

  # development / inspection / optimizations
  'awesome_print' => '1.2.0',
  'pry' => '0.9.12.4',
  'oj' => '2.5.3'
}

build do
  gems.each do |gem_name, gem_version|
    gem "install #{gem_name} --no-rdoc --no-ri -v #{gem_version}"
  end
end
