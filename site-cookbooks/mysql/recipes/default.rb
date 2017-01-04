%w{mysql mysql-server}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mysqld" do
  action [ :enable, :start ]
end
