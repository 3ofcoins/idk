#
# Cookbook Name:: idk
# Recipe:: default
#
# Copyright 2013, Maciej Pasternacki
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Add Git, but only if user doesn't have it installed
require 'chef/mixin/shell_out'
class << self
  include Chef::Mixin::ShellOut
end

begin
  shell_out! 'git --version'
rescue
  include_recipe 'git'
end

begin
  shell_out! 'git annex version'
rescue
  include_recipe 'git-annex'
end

#
# These should have been done by postinst, but it won't hurt to
# double-check in case the directory has been removed for some reason.

directory '/var/local/idk' do
  recursive true
end

directory '/var/local/idk/user' do
  mode '1777'
end
