three server
xxx.xxx.xxx.xxx secure-master
xxx.xxx.xxx.xxx secure-slave
virtualIP xxx.xxx.xxx.xxx

yum install nginx  keepalived -y
enable and restart both service in both server


vi /etc/keepalived/keepalived.conf

server one file config keep alive:
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

    track_script {
        chk_nginx
    }

    unicast_peer {
        xxx.xxx.xxx.xxx
    }
    virtual_ipaddress {
        xxx.xxx.xxx.xxx
    }
}


server two file config keepalive :
vrrp_script chk_nginx {
    script "pidof nginx"
    interval 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens192
    virtual_router_id 51
    priority 199
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }

    track_script {
        chk_nginx
    }

    unicast_peer {
        xxx.xxx.xxx.xxx
    }
    virtual_ipaddress {
        xxx.xxx.xxx.xxx
    }

}

server three file config Nginx loadbalancing:

vi /etc/nginx/nginx.conf
stream {
      upstream stream_backend {
        zone tcp_servers 64k;
        #server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;
        #server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;
        #server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;

        server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;
        server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;
        server xxx.xxx.xxx.xxx:443 max_fails=3 fail_timeout=15s;

    }

    server {
        listen 443;
        proxy_pass stream_backend;
        proxy_connect_timeout 1s;
    }

