#
# Cookbook Name:: jmxtrans
# Recipe:: install
#
# Copyright 2012, Bryan W. Berry
# - A huge thanks to Bryan for the original recipe
# Copyright 2014, Brandon Burton
#
# Apache 2.0 license
#

# include_recipe "ark"

user node['jmxtrans']['user'] do
  action :nothing
end.run_action(:create)

directory "#{node['jmxtrans']['install_prefix']}/jmxtrans" do
  owner node['jmxtrans']['user']
  group node['jmxtrans']['user']
  mode "0755"
  action :nothing
    # because we need the install to be on disk for
    # rendering, we force this to happen at compile time
end.run_action(:create)

remote_file "/opt/jmxtrans.zip" do
  source node['jmxtrans']['url']
  mode '0644'
  node['jmxtrans']['checksum']
  action :nothing
    # because we need the install to be on disk for
    # rendering, we force this to happen at compile time
end.run_action(:create)

execute "install jmxtrans" do
  command "unzip -q -o -u /opt/jmxtrans.zip -d #{node['jmxtrans']['install_prefix']}/jmxtrans"
  cwd "/opt"
  action :nothing
    # because we need the install to be on disk for
    # rendering, we force this to happen at compile time
end.run_action(:run)

# ark "jmxtrans" do
#   url node['jmxtrans']['url']
#   checksum node['jmxtrans']['checksum']
#   name "jmxtrans"
#   path '/opt'
#   owner node['jmxtrans']['user']
#   group node['jmxtrans']['user']
#   action :nothing
#       # because we need the install to be on disk for
#       # rendering, we force this to happen at compile time
# end.run_action(:put)

directory node['jmxtrans']['log_dir'] do
  owner node['jmxtrans']['user']
  group node['jmxtrans']['user']
  mode  "0755"
end

link "#{node['jmxtrans']['home']}/jmxtrans-all.jar" do
  to "#{node['jmxtrans']['home']}/jmxtrans-#{node['jmxtrans']['version']}-all.jar"
end

remote_file "#{node['jmxtrans']['home']}/jmxtrans.sh" do
  source "file://#{node['jmxtrans']['home']}/jmxtrans.sh"
  action :create
  owner node['jmxtrans']['user']
  group node['jmxtrans']['user']
  mode  "0755"
end
