require 'spec_helper'

context 'In Container' do
  describe service('nexus') do
    it { should be_running.under('systemd') }
  end

  context 'slow service start', retry: 10, retry_wait: 60 do
    it 'expect nexus to start eventually' do
      expect(command('journalctl -u nexus').stdout).to match /Started Sonatype Nexus OSS/
    end
  end

  describe process('java') do
    it { should be_running }
  end

  describe port(8081) do
    it { should be_listening }
  end
end
