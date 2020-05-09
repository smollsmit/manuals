#!/bin/bash

ansible-playbook -v -i inventory/hosts.cluster groups.yml

