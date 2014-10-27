Description
===========

I am the jmxtrans cookbook!

[jmxtrans](https://github.com/jmxtrans/jmxtrans) is an excellent tool
for transporting jmx data from your JVMs and into a graphing tool like
graphite or ganglia.

This cookbook uses the [YAMLConfig](https://github.com/jmxtrans/jmxtrans/wiki/YAMLConfig) support in jmxtrans because this allows you define smaller and easier to read *source* configuration files in YAML and the cookbook takes care of producing the JSON files that jmxtrans ultimately needs.

Recipes
=======

## install.rb

## service.rb

## config_render.rb

Attributes
==========

__The important attributes:__

* `node['jmxtrans']['install_prefix']` - defaults to '/opt', determines where
  everything else is put for jmxtrans
* `node['jmxtrans']['log_dir']` - logging defaults to '/var/log/jmxtrans'
* `node['jmxtrans']['templates_yaml_source']` - Defaults to nil. This needs to be set in your wrapper cookbook.
* `node['jmxtrans']['templates_yaml_destination']` - Defaults to nil. This needs to be set in your wrapper cookbook.

* `node['jmxtrans']['graphite']['host']` - defaults to 'graphite'
* `node['jmxtrans']['graphite']['port']` - default to 2003


Usage
=====

In order to use this cookbook you need to do the following:

1. You must override the following attributes
  - `default['jmxtrans']['templates_yaml_source']` - This should be set to a folder in `files/default` that contains your YAML templates and is a relative path. e.g. "templates_yaml".
  - `default['jmxtrans']['templates_yaml_destination']` - This should be set to the full path where the YAML files should be written on the filesystem and is a full path, e.g. `/opt/jmxtrans/configs/yaml/`.
2. Set your graphite configs, at minimum you need to set the hostname
  - `default['jmxtrans']['graphite']['host']` - This should be set to something reachable/resolvable by your jmxtrans server.
3. You need to have the following in the order shown below, in your wrapper cookbook.

```
# install jmxtrans
include_recipe "jmxtrans::install"
include_recipe "jmxtrans::service"

# let's configure jmxtrans
# - Per the jmxtrans README, create_yaml_templates_dir() must be
#   called before using jmxtrans::config_render
create_yaml_templates_dir(node['jmxtrans']['templates_yaml_source'],
 node['jmxtrans']['templates_yaml_destination'])
include_recipe "jmxtrans::config_render"
```

4. You can check out the [latest release](https://github.com/solarce/jmxtrans-wrapper/releases/) of my [jmxtrans-wrapper example cookbook](https://github.com/solarce/jmxtrans-wrapper)

Authors
=======

Bryan W. Berry, Copyright 2012, Apache 2.0 license
Brandon Burton, Copyright 2014, Apache 2.0 license
