two server
yum install nginx  keepalived -y
enable and restart both service in both server

vi /etc/keepalived/keepalived.conf
#! Configuration File for keepalived

global_defs {
   #notification_email {
   #  acassen@firewall.loc
   #  failover@firewall.loc
   #  sysadmin@firewall.loc
  # }
  # notification_email_from Alexandre.Cassen@firewall.loc
  # smtp_server 192.168.200.1
  # smtp_connect_timeout 30
  # router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
  # vrrp_strict
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}
vrrp_script chk_nginx {
    script "pidof nginx"
    interval 2
}

vrrp_instance VI_1 {
    state MASTER
    interface ens192
    virtual_router_id 51
    priority 200
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        185.238.92.216/32
    }

}




https://ahmermansoor.blogspot.com/2018/08/keepalived-configure-floating-ip-centos-7.html
