# Ceph-ansible configuration
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/3/html/installation_guide_for_red_hat_enterprise_linux/deploying-red-hat-ceph-storage#installing-a-red-hat-ceph-storage-cluster

## Debug
ceph config dump

## Run
ansible-playbook site.yml -i hm01_dev_ceph
ansible-playbook site.yml -i hm01_dev_ceph --limit clients
