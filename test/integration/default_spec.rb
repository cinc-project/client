describe command 'cinc-client --version' do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /^Cinc Client:/ }
end

describe command 'cinc-solo --version' do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /^Cinc Client:/ }
end

platform = os.family

describe command 'cinc-solo -l info' do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /Cinc Zero/ }
  its('stdout') { should match /Cinc Client/ }
  its('stdout') { should match /Cinc-client/ }
  its('stdout') { should_not match /Chef Infra Zero/ }
  its('stdout') { should_not match /Chef Infra Client/ }
  its('stdout') { should_not match /Chef-client/ }
  if platform == 'windows'
    its('stdout') { should match %r{C:/cinc/client.rb.} }
    its('stdout') { should match %r{C:/cinc} }
    its('stdout') { should_not match %r{C:/chef/client.rb} }
    its('stdout') { should_not match %r{C:/chef} }
  else
    its('stdout') { should match %r{/etc/cinc/client.rb} }
    its('stdout') { should match %r{/var/cinc} }
    its('stdout') { should_not match %r{/etc/chef/client.rb} }
    its('stdout') { should_not match %r{/var/chef} }
  end
end

if platform == 'windows'
  describe command 'C:\cinc-project\cinc\embedded\bin\cinc-zero.bat --version' do
    its('exit_status') { should eq 0 }
  end

  describe command 'cinc-auditor.bat version' do
    its('exit_status') { should eq 0 }
  end

  describe command 'cinc-auditor.bat detect' do
    its('exit_status') { should eq 0 }
  end
  describe command 'C:\cinc-project\cinc\embedded\bin\ruby.exe -ropenssl -e "puts OpenSSL.fips_mode"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /false/ }
  end

  describe command 'C:\cinc-project\cinc\embedded\bin\ruby.exe -ropenssl -e "puts OpenSSL.fips_mode=true"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /true/ }
  end
else
  describe command 'chef-solo -l info -o ""' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-solo/ }
    its('stdout') { should match /Cinc Zero/ }
    its('stdout') { should match /Cinc Client/ }
    its('stdout') { should match /Cinc-client/ }
    its('stdout') { should match %r{/etc/cinc/client.rb} }
    its('stdout') { should match %r{/var/cinc} }
    its('stdout') { should_not match /Chef Infra Zero/ }
    its('stdout') { should_not match /Chef Infra Client/ }
    its('stdout') { should_not match /Chef-client/ }
    its('stdout') { should_not match %r{/etc/chef/client.rb} }
    its('stdout') { should_not match %r{/var/chef} }
  end

  describe command '/opt/cinc/embedded/bin/cinc-zero --version' do
    its('exit_status') { should eq 0 }
  end

  describe command '/opt/cinc/bin/cinc-auditor version' do
    its('exit_status') { should eq 0 }
  end

  describe command '/opt/cinc/bin/cinc-auditor detect' do
    its('exit_status') { should eq 0 }
  end

  describe command '/opt/cinc/bin/inspec version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-auditor/ }
  end

  describe command 'chef-client --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-client/ }
    its('stdout') { should match /^Cinc Client:/ }
  end

  describe command 'chef-solo --version' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^Redirecting to cinc-solo/ }
    its('stdout') { should match /^Cinc Client:/ }
  end

  # FIPS is not supported on MacOS or aarch64
  unless os.family == 'darwin' || os.arch == 'aarch64'
    describe command '/opt/cinc/embedded/bin/ruby -ropenssl -e "puts OpenSSL.fips_mode"' do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /false/ }
    end

    describe command '/opt/cinc/embedded/bin/ruby -ropenssl -e "puts OpenSSL.fips_mode=true"' do
      its('exit_status') { should eq 0 }
      its('stdout') { should match /true/ }
    end
  end
end
