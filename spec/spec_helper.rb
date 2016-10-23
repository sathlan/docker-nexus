require 'serverspec'
require 'rspec/retry'
require 'docker'

set :backend, :exec

def compose()
  set :os, family: :redhat
  set :backend, :docker
  @image = `docker-compose build`.split(' ')[-1]
  dock_name = `docker-compose up 2>&1 1>/dev/null`.split("\n")[1].split(' ')[-1]
  @container = Docker::Container.get(dock_name)
  set :docker_container, @container.id
end

RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  # Set externally in the Jenkinsfile.
  container_id_var_name = "#{ENV['TARGET_HOST'].tr('-', '_').upcase}_ID"
  container_id = ENV[container_id_var_name]
  config.before :all do
    if !ENV['USE_DOCKER'].nil?
      if container_id.nil?
        compose
      else
        set :os, family: :redhat
        set :backend, :docker
        set :docker_container, container_id
        @container = Docker::Container.get(container_id)
      end
    end
  end
  config.after :all do
    if !ENV['USE_DOCKER'].nil?
      `docker-compose down` if container_id.nil?
    end
  end
end
