## Users

### Add user's group to host from inventory
```
ansible-playbook -i inventory/ep01_infra -l dns_servers -e "usergroup=devops" users.yml
```
