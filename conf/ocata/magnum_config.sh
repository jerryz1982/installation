function _magnum_configure() {
    crudini --set $MAGNUM_CONF api host $CTRL_MGMT_IP
    crudini --set $MAGNUM_CONF certificate cert_manager_type x509keypair
    crudini --set $MAGNUM_CONF cinder_client region_name RegionOne
    crudini --set $MAGNUM_CONF database connection mysql://$DB_USER_MAGNUM:$DB_PWD_MAGNUM@$DB_IP/magnum

    crudini --set $MAGNUM_CONF DEFAULT transport_url "rabbit://$RABBIT_LIST"

    crudini --set $MAGNUM_CONF keystone_authtoken admin_tenant_name service
    crudini --set $MAGNUM_CONF keystone_authtoken admin_user magnum $KEYSTONE_U_MAGNUM
    crudini --set $MAGNUM_CONF keystone_authtoken admin_password $KEYSTONE_U_PWD_MAGNUM

    crudini --set $MAGNUM_CONF keystone_authtoken www_authenticate_uri http://$CTRL_MGMT_IP:5000/v3
    crudini --set $MAGNUM_CONF keystone_authtoken auth_url http://$CTRL_MGMT_IP:35357
    crudini --set $MAGNUM_CONF keystone_authtoken project_domain_id default
    crudini --set $MAGNUM_CONF keystone_authtoken user_domain_id default
    crudini --set $MAGNUM_CONF keystone_authtoken auth_type password
    crudini --set $MAGNUM_CONF keystone_authtoken project_name $KEYSTONE_T_NAME_SERVICE
    crudini --set $MAGNUM_CONF keystone_authtoken username $KEYSTONE_U_MAGNUM
    crudini --set $MAGNUM_CONF keystone_authtoken password $KEYSTONE_U_PWD_MAGNUM
    crudini --set $MAGNUM_CONF oslo_messaging_notifications driver noop

    crudini --set $MAGNUM_CONF trust trustee_domain_name magnum
    crudini --set $MAGNUM_CONF trust trustee_domain_admin_name magnum_domain_admin
    crudini --set $MAGNUM_CONF trust trustee_domain_admin_password $DOMAIN_ADMIN_PASS
    crudini --set $MAGNUM_CONF trust trustee_keystone_interface public

    crudini --set $MAGNUM_CONF oslo_concurrency lock_path /var/lib/magnum/tmp

}
