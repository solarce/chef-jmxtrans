#
# Cookbook Name:: jmxtrans
# Recipe:: service
#
# Copyright 2012, Bryan W. Berry
# - A huge thanks to Bryan for the original recipe
# Copyright 2014, Brandon Burton
#
# Apache 2.0 license
#

template "/etc/default/jmxtrans" do
  source "jmxtrans_default.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, "service[jmxtrans]"
end

template "/etc/init/jmxtrans.conf" do
  source "jmxtrans.upstart.conf.erb"
  owner "root"
  group "root"
  mode  "0755"
  variables( :name => 'jmxtrans' )
  notifies :restart, "service[jmxtrans]"
end

# We don't start the service by default
if platform?("ubuntu")
  service "jmxtrans" do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :status => true, :reload => true
    action [ :enable]
  end
else
  service "jmxtrans" do
    supports :restart => true, :status => true, :reload => true
    action [ :enable]
  end
end
