title 'Windows Cinc executables'

control 'cinc-windows' do
  impact 1.0
  title 'Validate executables outputs on Windows'
  desc 'Outputs should not contain trademarks on Windows'
  only_if { os.family == 'windows' }

  describe command %q(cinc-solo -l info -o '""') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /Cinc Zero/ }
    its('stdout') { should match /Cinc Client/ }
    its('stdout') { should match /Cinc-client/ }
    its('stdout') { should_not match /Chef Infra Zero/ }
    its('stdout') { should_not match /Chef Infra Client/ }
    its('stdout') { should_not match /Chef-client/ }
    its('stdout') { should match %r{C:/cinc/client.rb.} }
    its('stdout') { should match %r{C:/cinc} }
    its('stdout') { should_not match %r{C:/chef/client.rb} }
    its('stdout') { should_not match %r{C:/chef} }
  end

  describe command 'C:\cinc-project\cinc\embedded\bin\cinc-zero.bat --version' do
    its('exit_status') { should eq 0 }
  end

  describe command 'cinc-auditor.bat version' do
    its('exit_status') { should eq 0 }
  end

  describe command 'cinc-auditor.bat detect' do
    its('exit_status') { should eq 0 }
  end

  describe command 'chef-client --version' do
    its('exit_status') { should eq 0 }
    # its('stderr') { should match /^Redirecting to cinc-client/ } # Train bug https://github.com/inspec/train/issues/288
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command %q(chef-solo -l info) do # No -o as escaping with wrapper in inspec under windows is a hell
    its('exit_status') { should eq 0 }
    # its('stderr') { should match /^Redirecting to cinc-solo/ } # Train bug https://github.com/inspec/train/issues/288
    its('stdout') { should match /Cinc Zero/ }
    its('stdout') { should match /Cinc Client/ }
    its('stdout') { should match /Cinc-client/ }
    its('stdout') { should_not match /Chef Infra Zero/ }
    its('stdout') { should_not match /Chef Infra Client/ }
    its('stdout') { should_not match /Chef-client/ }
    its('stdout') { should match %r{C:/cinc/client.rb.} }
    its('stdout') { should match %r{C:/cinc} }
    its('stdout') { should_not match %r{C:/chef/client.rb} }
    its('stdout') { should_not match %r{C:/chef} }
  end

  describe command 'inspec version' do
    its('exit_status') { should eq 0 }
  #  its('stderr') { should match /^Redirecting to cinc-auditor/ }
  end
end
