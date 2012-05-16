#
# Author:: Manuel Morales <manuelmorales@gmail.com>
# Cookbook Name:: application_node
# Provider:: node
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :before_compile do

  include_recipe "nodejs"

  new_resource.environment.update({
    "NODE_ENV" => new_resource.environment_name,
    "PATH" => [Gem.default_bindir, ENV['PATH']].join(':')
  })

end

action :before_deploy do

  new_resource.environment['NODE_ENV'] = new_resource.environment_name

  new_resource.restart_command "/etc/init.d/#{new_resource.name} hup" if !new_resource.restart_command

end

action :before_migrate do

  if new_resource.npm
    Chef::Log.info "Running npm install"
    execute "npm install" do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  end

end

action :before_symlink do
end

action :before_restart do

  new_resource = @new_resource

  runit_service new_resource.name do
    template_name 'node'
    cookbook 'application_node'
    options(
      :app => new_resource,
      :node_env => new_resource.environment_name
    )
    run_restart false
  end
end

action :after_restart do
end
