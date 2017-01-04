group node["user"] do
  group_name node["user"]
  action     [:create]
end

user node["user"] do
  comment  "#{node["user"]} user"
  group    node["user"]
  home     "/home/#{node["user"]}"
  supports :manage_home => true
  action   [:create, :manage]
end
