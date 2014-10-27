#
# libraries/config_render.rb
#
# Copyright 2014, Brandon Burton
#
# Apache 2.0 license
#

def create_yaml_templates_dir(templates_yaml_source, templates_yaml_destination)
  log("Creating #{templates_yaml_destination}")
  remote_directory templates_yaml_destination do
    source templates_yaml_source # files/default/templates_yaml
    files_owner node['jmxtrans']['user']
    files_group node['jmxtrans']['user']
    files_mode  "0755"
    owner node['jmxtrans']['user']
    group node['jmxtrans']['user']
    mode  "0755"
    purge true
    action :nothing
      # because we need all the templates on disk for
      # rendering, we force this to happen at compile time
  end.run_action(:create)
end

# renders the YAML template to later be rendered to JSON
def render_yaml_templates(templates_yaml)
  log("Rendering YAML Templates")
  templates = Dir[templates_yaml]
  # Render each yaml template out to a yaml file
  templates.each do | template |
    log("Rendering YAML template: #{template}")
    file_name = template.split('/').last.split('.erb')[0]

    template "#{node['jmxtrans']['config_dir']}/yaml/#{file_name}" do
      source template
      owner node['jmxtrans']['user']
      group node['jmxtrans']['user']
      mode  "0755"
      local true
      variables({
           :graphite_host => node['jmxtrans']['graphite']['host'],
           :graphite_port => node['jmxtrans']['graphite']['port'] 
        })
      action :nothing
    end.run_action(:create)
  end
end

# We'll use the tool jmxtrans ship to render the json configs from our YAML files
def render_json (yaml_files)
  files = Dir[yaml_files]
  log("Rendering JSON configs for jmxtrans")
  files.each do | yaml_file |
    log("Rendering to JSON: #{yaml_file}")
    execute "render json" do
      command "python #{node['jmxtrans']['home']}/tools/yaml2jmxtrans.py #{yaml_file}"
      cwd "#{node['jmxtrans']['config_dir']}/json"
      action :run
    end
  end

  json_files = Dir["#{node['jmxtrans']['config_dir']}/json"]

  json_files.each do | json_file |
    log("Rendering JSON file: #{json_file}}")
  end
end

