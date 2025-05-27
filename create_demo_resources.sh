FILE="CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
if ! test -f $FILE; then
  wget "https://cloud.centos.org/centos/9-stream/x86_64/images/"$FILE
fi
openstack image create --container-format=bare --disk-format=qcow2 \
    --file $FILE osm_demo_image

openstack keypair create osm_demo_keypair >osm_demo_keypair.pem
chmod 600 osm_demo_keypair.pem

openstack network create osm_demo_network
openstack subnet create --subnet-range 70.0.20.0/24 --dhcp --network osm_demo_network osm_demo_subnet

openstack router create osm_demo_router
#openstack router set osm_demo_router --external-gateway public
openstack router add subnet osm_demo_router osm_demo_subnet

openstack flavor create --ram 1024 --disk 2 --vcpus 1 osm_demo_flavor 
openstack server create --flavor osm_demo_flavor --image osm_demo_image --network osm_demo_network --key-name osm_demo_keypair  osm_demo_server

