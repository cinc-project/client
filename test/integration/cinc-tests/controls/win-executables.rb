title 'Windows Cinc executables'

control 'cinc-windows' do
  impact 1.0
  title 'Validate executables outputs on Windows'
  desc 'Outputs should not contain trademarks on Windows'
  only_if { os.family == 'windows' }

  describe command 'cinc-solo -l info -o ""' do
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

  describe command 'C:\cinc-project\cinc\bin\inspec version' do
    its('exit_status') { should eq 0 }
    # Wrapper is broken in windows
    # its('stdout') { should match /^Redirecting to cinc-auditor/ }
  end
end
