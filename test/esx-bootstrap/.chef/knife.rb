# 
# knife configuration that is honored by knife-solo, see 
# https://github.com/matschaffer/knife-solo/wiki/Upgrading-to-0.3.0 
#
log_level                 :info
log_location              STDOUT
data_bag_path             "data_bags"
encrypted_data_bag_secret "data_bag_key"
role_path                 "roles"
cookbook_path             "cookbooks/#{ENV['CURRENT_APP_COOKBOOK']}"