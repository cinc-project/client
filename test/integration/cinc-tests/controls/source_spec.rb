control 'Validate source tarballs' do
  impact 1.0
  title 'Ensure source tarball are correct'
  desc 'Ensure the tarballs match their respective shasum'
  only_if { ENV['SOURCE_TEST'] == true }

  describe command 'bash -c "cd source/*/cinc/ && sha256sum -c cinc-[0-9]*.tar.xz.sha256sum"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /OK$/ }
  end
  describe command 'bash -c "cd source/*/cinc/ && sha256sum -c cinc-full-[0-9]*.tar.xz.sha256sum"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /OK$/ }
  end
  describe command 'bash -c "cd source/*/cinc/ && sha512sum -c cinc-[0-9]*.tar.xz.sha512sum"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /OK$/ }
  end
  describe command 'bash -c "cd source/*/cinc/ && sha512sum -c cinc-full-[0-9]*.tar.xz.sha512sum"' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /OK$/ }
  end
end