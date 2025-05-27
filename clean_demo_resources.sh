openstack server delete osm_demo_server
openstack volume delete osm_demo_volume

openstack router remove subnet osm_demo_router osm_demo_subnet
openstack router delete osm_demo_router

openstack subnet delete osm_demo_subnet
openstack network delete osm_demo_network

openstack keypair delete osm_demo_keypair

#openstack router set osm_demo_router --external-gateway public





