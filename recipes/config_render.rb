#
# Cookbook Name:: jmxtrans
# Recipe:: config_render
#
# Copyright 2012, Bryan W. Berry
# - A huge thanks to Bryan for the original recipe
# Copyright 2014, Brandon Burton
#
# Apache 2.0 license
#

##
# **Note**: this recipe uses methods defined in
#           libraries/config_render.rb
##

if node['jmxtrans']['templates_yaml_destination'] != nil

  directory node['jmxtrans']['config_dir'] do
    owner node['jmxtrans']['user']
    group node['jmxtrans']['user']
    mode  "0755"
    action :nothing
    # because we need this folder on disk for
    # rendering, we force this to happen at compile time
  end.run_action(:create)

  config_file_dirs = ['yaml', 'json']

  config_file_dirs.each do | dir |
    directory "#{node['jmxtrans']['config_dir']}/#{dir}" do
      owner node['jmxtrans']['user']
      group node['jmxtrans']['user']
      mode  "0755"
      action :nothing
      # because we need these folders on disk for
      # rendering, we force this to happen at compile time
    end.run_action(:create)
  end


  if !Dir["#{node['jmxtrans']['config_dir']}/yaml/*.yaml"].empty?
  log ("Cleaning out YAML files before rendering templates")
    execute "clean up yaml files" do
      command "rm #{node['jmxtrans']['config_dir']}/yaml/*.yaml"
      action :nothing
      # because we need this to happen when we render the yaml
      # templates, we force this to happen at compile time
    end.run_action(:run)
  end
  # YAML Templates should be added to your wrapper cookbook and
  # you should override ['jmxtrans']['templates_yaml'] in your wrapper
  render_yaml_templates("#{node['jmxtrans']['templates_yaml_destination']}/*.yaml.erb")

  if !Dir["#{node['jmxtrans']['config_dir']}/json/*.json"].empty?
  log ("Cleaning out json files before rendering json")
    execute "clean up json files" do
      command "rm #{node['jmxtrans']['config_dir']}/json/*.json"
      action :run
    end
  end

  # Render out the actual JSON that jmxtrans will use for its configuration
  render_json("#{node['jmxtrans']['config_dir']}/yaml/*.yaml")


else
  log("You need to set node['jmxtrans']['templates_yaml_source'] and
    node['jmxtrans']['templates_yaml_destination'] in your wrapper cookbook")
end


