# plugin系
%w{gcc git openssl-devel readline-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

# rbenv
git "/home/#{node['ruby-env']['user']}/.rbenv" do
  repository node['ruby-env']['rbenv-url']
  reference "master"
  action :sync
  user node['ruby-env']['user']
end

# .bash_profileへPATHを通す
%w{.bash_profile}.each do |filename|
  template filename do
      source "#{filename}.erb"
      path "/home/#{node['ruby-env']['user']}/#{filename}"
      mode 0644
      owner node['ruby-env']['user']
  end
end

# ruby-buildをinstallするpluginsディレクトリを作成する
directory "/home/#{node['ruby-env']['user']}/.rbenv/plugins" do
  owner node['ruby-env']['user']
  mode 0755
  action :create
end

# ruby-build
git "/home/#{node['ruby-env']['user']}/.rbenv/plugins/ruby-build" do
  repository node['ruby-env']['ruby-build-url']
  action :sync
  user node['ruby-env']['user']
end

# ruby
execute "rbenv install #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv install #{node['ruby-env']['version']}"
  user node['ruby-env']['user']
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/versions/#{node['ruby-env']['version']}") }
end

# installしたrubyのversionをglobalに設定する
execute "rbenv global #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv global #{node['ruby-env']['version']}"
  user node['ruby-env']['user']
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
end

%w{rbenv-rehash bundler}.each do |gem|
  execute "gem install #{gem}" do
    command "/home/#{node['ruby-env']['user']}/.rbenv/shims/gem install #{gem}"
    user node['ruby-env']['user']
    environment 'HOME' => "/home/#{node['ruby-env']['user']}"
    not_if "/home/#{node['ruby-env']['user']}/.rbenv/shims/gem list | grep #{gem}"
  end
end
