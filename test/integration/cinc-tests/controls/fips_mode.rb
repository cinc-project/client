title 'Check fips mode'
# FIPS is not supported on MacOS, aarch64 and ppc64le
control 'Validate fips mode' do
  impact 1.0
  title 'Test calling OpenSSL.fips_mode'
  desc 'Test that fips modes is enabled on supported os and architectures'
  only_if { os.family != 'darwin' && os.arch != 'aarch64' && os.arch != 'ppc64le' }

  ruby_path = '/opt/cinc/embedded/bin/ruby'
  # Overwrite the ruby_path if we're under windows
  ruby_path = 'C:\cinc-project\cinc\embedded\bin\ruby.exe' if os.family == 'windows'

  describe command "#{ruby_path} -ropenssl -e 'puts OpenSSL.fips_mode'" do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /false/ }
  end

  describe command "#{ruby_path} -ropenssl -e 'puts OpenSSL.fips_mode=true'" do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /true/ }
  end
end
