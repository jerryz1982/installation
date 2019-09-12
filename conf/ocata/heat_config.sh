function _heat_configure() {
    crudini --set $HEAT_CONF database connection mysql://$DB_USER_HEAT:$DB_PWD_HEAT@$DB_IP/heat

    crudini --set $HEAT_CONF DEFAULT transport_url "rabbit://$RABBIT_LIST"
    crudini --set $HEAT_CONF DEFAULT log_file heat.log
    crudini --set $HEAT_CONF DEFAULT log_dir /var/log/heat
    crudini --set $HEAT_CONF DEFAULT heat_metadata_server_url http://$CTRL_MGMT_IP:8000
    crudini --set $HEAT_CONF DEFAULT heat_waitcondition_server_url http://$CTRL_MGMT_IP:8000/v1/waitcondition
    crudini --set $HEAT_CONF DEFAULT stack_domain_admin heat_domain_admin
    crudini --set $HEAT_CONF DEFAULT stack_domain_admin_password $HEAT_DOMAIN_ADMIN_PASS
    crudini --set $HEAT_CONF DEFAULT stack_user_domain_name heat

    crudini --set $HEAT_CONF keystone_authtoken auth_uri http://$CTRL_MGMT_IP:5000
    crudini --set $HEAT_CONF keystone_authtoken auth_url http://$CTRL_MGMT_IP:35357
    crudini --set $HEAT_CONF keystone_authtoken memcached_servers $CTRL_MGMT_IP:11211
    crudini --set $HEAT_CONF keystone_authtoken project_domain_id default
    crudini --set $HEAT_CONF keystone_authtoken user_domain_id default
    crudini --set $HEAT_CONF keystone_authtoken auth_type password
    crudini --set $HEAT_CONF keystone_authtoken project_name $KEYSTONE_T_NAME_SERVICE
    crudini --set $HEAT_CONF keystone_authtoken username $KEYSTONE_U_HEAT
    crudini --set $HEAT_CONF keystone_authtoken password $KEYSTONE_U_PWD_HEAT
    crudini --set $HEAT_CONF oslo_messaging_notifications driver noop

    crudini --set $HEAT_CONF trustee user_domain_name default
    crudini --set $HEAT_CONF trustee username $KEYSTONE_U_HEAT
    crudini --set $HEAT_CONF trustee password $KEYSTONE_U_PWD_HEAT
    crudini --set $HEAT_CONF trustee auth_type password
    crudini --set $HEAT_CONF trustee auth_url http://$CTRL_MGMT_IP:35357
    crudini --set $HEAT_CONF clients_keystone auth_uri http://$CTRL_MGMT_IP:35357
    crudini --set $HEAT_CONF ec2authtoken auth_uri http://$CTRL_MGMT_IP:5000



}
