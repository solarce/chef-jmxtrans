# Default Attributes

# Various folders
default['jmxtrans']['install_prefix'] = '/opt'
default['jmxtrans']['home'] = "#{node['jmxtrans']['install_prefix']}/jmxtrans"
default['jmxtrans']['config_dir'] = "#{node['jmxtrans']['home']}/configs"
default['jmxtrans']['templates_yaml_source'] = nil # This needs to be set in your wrapper cookbook
default['jmxtrans']['templates_yaml_destination'] = nil # This needs to be set in your wrapper cookbook
default['jmxtrans']['log_dir'] = '/var/log/jmxtrans'

# Used for both user and group by default
default['jmxtrans']['user'] = 'jmxtrans'

# Installation details
default['jmxtrans']['url'] = 'https://github.com/solarce/jmxtrans/releases/download/v246/jmxtrans-v246-withjar.zip'
default['jmxtrans']['checksum'] = '8e6aa0dda175046beddf06204cda5baf298df52c193eb1bab81ce20da159fcc3'
default['jmxtrans']['version'] = "v246"

# Various settings
default['jmxtrans']['heap_size'] = '512'
default['jmxtrans']['run_interval'] = '60'
default['jmxtrans']['log_level'] = 'debug'

# Used in configuration rendering
default['jmxtrans']['graphite']['host'] = 'graphite'
default['jmxtrans']['graphite']['port'] = '2003'
