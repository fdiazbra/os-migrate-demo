# os-migrate-demo
OS Migrate provides a framework for exporting and importing resources
between two clouds. It's a collection of Ansible playbooks that
provide the basic functionality, but may not fit each use case out of
the box. You can craft custom playbooks using the OS Migrate
collection pieces (roles and modules) as building blocks.

More information in the official [os-migrate repository](https://github.com/os-migrate/os-migrate) or the [documentation](https://os-migrate.github.io/os-migrate/).

Content required to migrate a OSP workload with an attached cinder volume to another OSP cloud. 

## Requirements and configuration:
* Source and destination cloud deployed
* Get the os-migrate repo and use the toolbox to deploy the migrator host:
```
git clone https://github.com/os-migrate/os-migrate.git
cd os-migrate
make toolbox-build
./toolbox/run
```
* Auth parametes filled in the `os-migrate-demo-clouds.yml` file like this:
```
os_migrate_src_auth:
  auth_url: https://source-cloud-url:port/v3
  username: "your-username"
  project_id: your-project-id
  project_name: "your-project-name"
  user_domain_name: "your-user-domain"
  password: "your-password"
os_migrate_src_region_name: regionOne
os_migrate_dst_auth:
  auth_url: https://destination-cloud-url:13000
  username: "your-username"
  project_id: your-project-id
  project_name: "your-project-name"
  user_domain_name: "your-user-domain"
  password: "your-password"
os_migrate_dst_region_name: regionOne
```
* Vars file like `os-migrate-demo.yml` included in this repository.

* For this demo we have created the playbooks: `export_pre_workload_demo.yml` and `import_pre_workload_demo.yml` that will execute the required roles.
* Create the Makefile entries for handling the conversion hosts:
```
deploy-conversion-hosts: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/deploy_conversion_hosts.yml

delete-conversion-hosts: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/delete_conversion_hosts.yml
```
* Create the Makefile entries for executing the playbooks:
```
execute-export-pre-workload-demo: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/export_pre_workload_demo.yml

execute-import-pre-workload-demo: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/import_pre_workload_demo.yml

execute-export-workload-demo: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/export_workloads.yml

execute-import-workload-demo: reinstall
	set -euo pipefail; \
	if [ -z "$${VIRTUAL_ENV:-}" ]; then \
		echo "Sourcing venv."; \
		source /root/venv/bin/activate; \
	fi; \
	ansible-playbook \
		-v \
		-i $(OS_MIGRATE)/localhost_inventory.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-vars.yml \
		-e @/root/os_migrate/os_migrate/os-migrate-demo-clouds.yml \
		$(OS_MIGRATE)/playbooks/import_workloads.yml
```
## Procedure:
* Deploy the resources in the source cloud with the script `create_demo_resources.sh`

### Pre-workload migration:
* Execute the export pre-workload playbook:
```
make execute-export-pre-workload-demo
```
Check the serialized files for network, subnetwork, keypair and router. Modify them in case of need.

* Execute the import pre-workload playbook:
```
make execute-import-pre-workload-demo
```
Check that there is not any error during the execution and also that the resources are created in the destination cloud.


### Workload migration:
* Execute the export workload playbook:
```
make execute-export-workload-demo
```
Check the serialized file for the workload. It should have a volume attached to it called `osm_demo_volume`

* Execute the import workload playbook:
```
make execute-import-workload-demo
```
Check that there is not any error during the execution and also that the resources are created in the destination cloud.


## Clean up:

Clean both source and destination clouds with the script `clean_demo_resources.sh`
