# 
# configure kitchen path on the server allowing us to adapt 
# the cookbook_path in `solo.rb`
#
# see https://github.com/matschaffer/knife-solo/issues/199#issuecomment-13820473
#
knife[:solo_path] = '/tmp/chef-solo'