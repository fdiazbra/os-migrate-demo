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
openstack router set osm_demo_router --external-gateway provider_net_shared_3
openstack router add subnet osm_demo_router osm_demo_subnet

openstack server create --flavor g.standard.medium --image osm_demo_image --network osm_demo_network --key-name osm_demo_keypair  osm_demo_server
openstack volume create osm_demo_volume --size 1
openstack server add volume osm_demo_server osm_demo_volume



