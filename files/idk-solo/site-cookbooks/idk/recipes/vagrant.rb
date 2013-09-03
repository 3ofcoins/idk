vagrant_version = '1.2.7'
vagrant_base_url = 'http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243'

case "#{node['platform_family']}-#{node['kernel']['machine']}"
when /^mac_os_x/
  node.set['vagrant']['url'] = "#{vagrant_base_url}/Vagrant-#{vagrant_version}.dmg"
  node.set['vagrant']['checksum'] = '75c720eda0cbe6b2a2b19e38757ba4c34fbc57095ab4cc1459609bd242418129'
when 'debian-x86_64'
  node.set['vagrant']['url'] = "#{vagrant_base_url}/vagrant_#{vagrant_version}_x86_64.deb"
  node.set['vagrant']['checksum'] = '4e6cbbe820fd096355eb0e878436fa3c6468ae5969c60f2a8a3ceb6ec6059c5e'
when /^debian-i.86$/
  node.set['vagrant']['url'] = "#{vagrant_base_url}/vagrant_#{vagrant_version}_i686.deb"
  node.set['vagrant']['checksum'] = 'fe3fade875a46c4d763ea7da112a9b5efef94d813d407e110a9d09c9b97d3971'
when /^(fedora|rhel)-x86_64$/
  node.set['vagrant']['url'] = "#{vagrant_base_url}/vagrant_#{vagrant_version}_x86_64.rpm"
  node.set['vagrant']['checksum'] = 'ca0b2edd7738e33ca9d3d5437b36ed9d3b6c3bdfac10b09c3617f2a56216b04f'
when /^(fedora|rhel)-i.86$/
  node.set['vagrant']['url'] = "#{vagrant_base_url}/vagrant_#{vagrant_version}_i686.rpm"
  node.set['vagrant']['checksum'] = '9f93c52d7217e9a28b7ae3fff77c855bc777ecd2b856d3cc5dfd4cbffcbcbb37'
end

include_recipe 'vagrant'
