# encoding: UTF-8
#
# Cookbook Name:: openstack-dashboard
# Attributes:: default
#
# Copyright 2012, AT&T, Inc.
# Copyright 2013-2014, IBM, Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default['openstack']['dashboard']['custom_template_banner'] = '
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
'

default['openstack']['dashboard']['server_type'] = 'apache2'

default['openstack']['dashboard']['debug'] = false

# The Keystone role used by default for users logging into the dashboard
default['openstack']['dashboard']['keystone_default_role'] = '_member_'

# This is the name of the Chef role that will install the Keystone Service API
default['openstack']['dashboard']['keystone_service_chef_role'] = 'keystone'

default['openstack']['dashboard']['server_hostname'] = nil
default['openstack']['dashboard']['use_ssl'] = true
default['openstack']['dashboard']['ssl']['cert_url'] = nil
default['openstack']['dashboard']['ssl']['key_url'] = nil
# When using a remote certificate and key, the names of the actual installed certificate
# and key in the file system are determined by the following two attributes.
# If you want the name of the installed files to match the name of the files from the URL,
# they need to be manually set below, if not the conventional horizon.* names will be used.
default['openstack']['dashboard']['ssl']['cert'] = 'horizon.pem'
default['openstack']['dashboard']['ssl']['key'] = 'horizon.key'
# Which versions of the SSL/TLS protocol will be accepted in new connections.
default['openstack']['dashboard']['ssl']['protocol'] = 'All -SSLv2 -SSLv3'

# List of hosts/domains the dashboard can serve. This should be changed, a '*'
# allows everything
default['openstack']['dashboard']['allowed_hosts'] = ['*']

default['openstack']['dashboard']['swift']['enabled'] = 'False'

default['openstack']['dashboard']['theme'] = 'default'

default['openstack']['dashboard']['apache']['sites-path'] = "#{node['apache']['dir']}/openstack-dashboard.conf"

# Allow TRACE method
#
# Set to "extended" to also reflect the request body (only for testing and
# diagnostic purposes).
#
# Set to one of:  On | Off | extended
default['openstack']['dashboard']['traceenable'] = node['apache']['traceenable']

default['openstack']['dashboard']['http_port'] = 80
default['openstack']['dashboard']['https_port'] = 443

default['openstack']['dashboard']['secret_key_content'] = nil

default['openstack']['dashboard']['ssl_no_verify'] = 'True'
default['openstack']['dashboard']['ssl_cacert'] = nil

default['openstack']['dashboard']['webroot'] = '/'

# Dashboard specific database packages
# Put common ones here and platform specific ones below.
default['openstack']['dashboard']['db_python_packages'] = {
  db2: [],
  mysql: [],
  postgresql: [],
  sqlite: []
}

# The hash algorithm to use for authentication tokens. This must match the hash
# algorithm that the identity (Keystone) server and the auth_token middleware
# are using. Allowed values are the algorithms supported by Python's hashlib
# library.
default['openstack']['dashboard']['hash_algorithm'] = 'md5'

case node['platform_family']
when 'rhel'
  default['openstack']['dashboard']['horizon_user'] = 'apache'
  default['openstack']['dashboard']['horizon_group'] = 'apache'
  default['openstack']['dashboard']['secret_key_path'] = '/usr/share/openstack-dashboard/openstack_dashboard/local/.secret_key_store'
  default['openstack']['dashboard']['ssl']['dir'] = '/etc/pki/tls'
  default['openstack']['dashboard']['local_settings_path'] = '/etc/openstack-dashboard/local_settings'
  default['openstack']['dashboard']['django_path'] = '/usr/share/openstack-dashboard'
  default['openstack']['dashboard']['login_url'] = "#{node['openstack']['dashboard']['webroot']}auth/login/"
  default['openstack']['dashboard']['logout_url'] = "#{node['openstack']['dashboard']['webroot']}auth/logout/"
  default['openstack']['dashboard']['login_redirect_url'] = node['openstack']['dashboard']['webroot']
  default['openstack']['dashboard']['db_python_packages']['db2'] = ['python-ibm-db-django']
  default['openstack']['dashboard']['platform'] = {
    'horizon_packages' => ['openstack-dashboard'],
    'memcache_python_packages' => ['python-memcached'],
    'package_overrides' => ''
  }
  default['openstack']['dashboard']['apache']['sites-path'] = "#{node["apache"]["dir"]}/sites-available/openstack-dashboard.conf"
when 'suse'
  default['openstack']['dashboard']['horizon_user'] = 'wwwrun'
  default['openstack']['dashboard']['horizon_group'] = 'www'
  default['openstack']['dashboard']['secret_key_path'] = '/srv/www/openstack-dashboard/openstack_dashboard/local/.secret_key_store'
  default['openstack']['dashboard']['ssl']['dir'] = '/etc/ssl'
  default['openstack']['dashboard']['local_settings_path'] = '/srv/www/openstack-dashboard/openstack_dashboard/local/local_settings.py'
  default['openstack']['dashboard']['django_path'] = '/srv/www/openstack-dashboard'
  default['openstack']['dashboard']['login_url'] = nil
  default['openstack']['dashboard']['logout_url'] = nil
  default['openstack']['dashboard']['login_redirect_url'] = nil
  default['openstack']['dashboard']['platform'] = {
    'horizon_packages' => ['openstack-dashboard'],
    'memcache_python_packages' => ['python-python-memcached'],
    'package_overrides' => ''
  }
  default['openstack']['dashboard']['apache']['sites-path'] = "#{node["apache"]["dir"]}/conf.d/openstack-dashboard.conf"
when 'debian'
  default['openstack']['dashboard']['horizon_user'] = 'horizon'
  default['openstack']['dashboard']['horizon_group'] = 'horizon'
  default['openstack']['dashboard']['secret_key_path'] = '/var/lib/openstack-dashboard/secret_key'
  default['openstack']['dashboard']['ssl']['dir'] = '/etc/ssl'
  default['openstack']['dashboard']['local_settings_path'] = '/etc/openstack-dashboard/local_settings.py'
  default['openstack']['dashboard']['django_path'] = '/usr/share/openstack-dashboard'
  default['openstack']['dashboard']['login_url'] = nil
  default['openstack']['dashboard']['logout_url'] = nil
  default['openstack']['dashboard']['login_redirect_url'] = nil
  default['openstack']['dashboard']['platform'] = {
    'memcache_python_packages' => ['python-memcache'],
    'package_overrides' => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
  # lessc became node-less in 12.10
  if node['lsb']['release'] > '12.04'
    default['openstack']['dashboard']['platform']['horizon_packages'] = ['node-less', 'openstack-dashboard']
  else
    default['openstack']['dashboard']['platform']['horizon_packages'] = ['lessc', 'openstack-dashboard']
  end
  default['openstack']['dashboard']['apache']['sites-path'] = "#{node["apache"]["dir"]}/sites-available/openstack-dashboard.conf"
end

default['openstack']['dashboard']['dash_path'] = "#{node['openstack']['dashboard']['django_path']}/openstack_dashboard"
default['openstack']['dashboard']['static_path'] = "#{node['openstack']['dashboard']['django_path']}/static"
default['openstack']['dashboard']['stylesheet_path'] = '/usr/share/openstack-dashboard/openstack_dashboard/templates/_stylesheets.html'
default['openstack']['dashboard']['wsgi_path'] = node['openstack']['dashboard']['dash_path'] + '/wsgi/django.wsgi'
default['openstack']['dashboard']['wsgi_socket_prefix'] = nil
default['openstack']['dashboard']['session_backend'] = 'memcached'

default['openstack']['dashboard']['ssl_offload'] = false
default['openstack']['dashboard']['plugins'] = nil

default['openstack']['dashboard']['file_upload_temp_dir'] = nil

default['openstack']['dashboard']['error_log'] = 'openstack-dashboard-error.log'
default['openstack']['dashboard']['access_log'] = 'openstack-dashboard-access.log'

default['openstack']['dashboard']['help_url'] = 'http://docs.openstack.org'

default['openstack']['dashboard']['csrf_cookie_secure'] = true
default['openstack']['dashboard']['session_cookie_secure'] = true

default['openstack']['dashboard']['keystone_multidomain_support'] = false
default['openstack']['dashboard']['api']['auth']['version'] = node['openstack']['api']['auth']['version']

case node['openstack']['dashboard']['api']['auth']['version']
when 'v2.0'
  default['openstack']['dashboard']['identity_api_version'] =  2.0
when 'v3.0'
  default['openstack']['dashboard']['identity_api_version'] = 3
end

default['openstack']['dashboard']['volume_api_version'] = 2
default['openstack']['dashboard']['keystone_default_domain'] = 'Default'
default['openstack']['dashboard']['console_type'] = 'AUTO'

default['openstack']['dashboard']['keystone_backend']['name'] = 'native'
default['openstack']['dashboard']['keystone_backend']['can_edit_user'] = true
default['openstack']['dashboard']['keystone_backend']['can_edit_group'] = true
default['openstack']['dashboard']['keystone_backend']['can_edit_project'] = true
default['openstack']['dashboard']['keystone_backend']['can_edit_domain'] = true
default['openstack']['dashboard']['keystone_backend']['can_edit_role'] = true

default['openstack']['dashboard']['log_level']['horizon'] = 'INFO'
default['openstack']['dashboard']['log_level']['openstack_dashboard'] = 'INFO'
default['openstack']['dashboard']['log_level']['novaclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['cinderclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['keystoneclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['glanceclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['neutronclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['heatclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['ceilometerclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['troveclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['swiftclient'] = 'INFO'
default['openstack']['dashboard']['log_level']['openstack_auth'] = 'INFO'
default['openstack']['dashboard']['log_level']['nose.plugins.manager'] = 'INFO'
default['openstack']['dashboard']['log_level']['django'] = 'INFO'

default['openstack']['dashboard']['password_autocomplete'] = 'on'
default['openstack']['dashboard']['simple_ip_management'] = false
default['openstack']['dashboard']['neutron']['enable_lb'] = false
default['openstack']['dashboard']['neutron']['enable_quotas'] = true
default['openstack']['dashboard']['neutron']['enable_firewall'] = false
default['openstack']['dashboard']['neutron']['enable_vpn'] = false

# Allow for misc sections to be added to the local_settings template
# For example: {
#                'CUSTOM_CONFIG_A' => {
#                  'variable1': 'value1',
#                  'variable2': 'value2'
#                }
#                'CUSTOM_CONFIG_B' => {
#                  'variable1': 'value1',
#                  'variable2': 'value2'
#                }
#              }
# will generate:
#  CUSTOM_CONFIG_A = {
#    'varable1': 'value1',
#    'varable2': 'value2',
#  }
#  CUSTOM_CONFIG_A = {
#    'varable1': 'value1',
#    'varable2': 'value2',
#  }
default['openstack']['dashboard']['misc_local_settings'] = nil
