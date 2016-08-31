require 'spec_helper'

# https://gist.github.com/garethr/6579190
# https://github.com/sophsec/ruby-nmap
# https://github.com/vincentbernat/serverspec-example/blob/master/viewer/index.html

context 'From host' do
  # The start is verrry slow
  describe command('docker ps') do
    its(:stdout) { should match /#{ENV['DOCKER_IMAGE']}.*\/sbin\/init.* Up/ }
  end
end
