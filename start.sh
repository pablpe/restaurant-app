#!/bin/bash

#directories
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
terraform_dir="terraform"
ansible_dir="ansible"

function menu(){
    clear
    echo "##### MAIN MENU #####"
    echo "1 - terraform"
    echo "2 - ansible"
    echo "0 - exit"
}

function terraform_menu(){
    clear
    echo "##### TERRAFORM MENU #####"
    echo "1 - terraform clean"
    echo "2 - terraform init"
    echo "3 - terraform fmt"
    echo "4 - terraform validate"
    echo "5 - terraform plan"
    echo "6 - terraform apply"
    echo "7 - terraform destroy"
    echo "0 - main menu"
}

function ansible_menu(){
    clear
    echo "##### ANSIBLE MENU #####"
    echo "1 - generate inventory file"
    echo "2 - ping ansible inventory"
    echo "3 - run ansible setup playbook"
    echo "0 - main menu"
}

function terraform_function(){

    terraform_loop="9"
    while [ "$terraform_loop" != "0" ]
    do
        terraform_menu
        read user_choice

        terraform_loop=$user_choice

        echo -e "\n\n"

        case $user_choice in
        "1")
            echo "Cleaning terraform directories"

            cd "$terraform_dir"

            rm -rf .terraform .terraform.lock.hcl terraform.tfstate.backup

            echo -e "\n Cleaning done"

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..

            ;;
        "2")
            echo "Initiating terraform . . ."

            cd "$terraform_dir"

            terraform init || { echo "Terraform init failed"; return; }

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..

            ;;
        "3")
            echo "Initiating terraform format . . ."

            cd "$terraform_dir"

            terraform fmt

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..

            ;;
        "4")
            echo "Initiating terraform validate . . ."

            cd "$terraform_dir"

            terraform validate

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..

            ;;
        "5")
            echo "Initiating terraform plan . . ."

            cd "$terraform_dir"

            terraform plan

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..
            ;;
        "6")
            echo "Running terraform apply . . . "

            cd "$terraform_dir"

            terraform apply -auto-approve

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..
            ;;
        "7")
            echo "Running terraform destroy . . . "

            cd "$terraform_dir"

            terraform destroy -auto-approve

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue

            cd ..
            ;;
        "0")
            echo -e "\n\n Exiting . . ."
            ;;
        esac
    done
}

function ansible_function(){
    ansible_value="9"

    while [ "$ansible_value" != "0" ]
    do
        ansible_menu
        read user_choice

        ansible_value=$user_choice

        echo -e "\n\n"

        case $user_choice in
        "1")
            echo "Cleaning inventory file"
            >ansible/inventory

            echo -e "\nGenerating ansible invetory . . . "

            cd "$terraform_dir"

            haproxy_ip=$(terraform output -raw haproxy)
            frontend_ip=$(terraform output -raw frontend)
            auth_ip=$(terraform output -raw auth)
            discount_ip=$(terraform output -raw discount)
            items_ip=$(terraform output -raw items)
            auth_loadbalancer_ip=$(terraform output -raw auth-loadbalancer)
            discount_loadbalancer_ip=$(terraform output -raw discount-loadbalancer)
            items_loadbalancer_ip=$(terraform output -raw items-loadbalancer)

            echo -e "\n Gathering IPs"
            echo "haproxy       : $haproxy_ip"
            echo "frontend      : $frontend_ip"
            echo "auth          : $auth_ip"
            echo "discount      : $discount_ip"
            echo "items         : $items_ip"
            echo "loadbalancer - auth  : $auth_loadbalancer_ip"
            echo "loadbalancer - discount : $discount_loadbalancer_ip"
            echo "loadbalancer - items : $items_loadbalancer_ip"

            echo -e "\n Generating ansible inventory file"
            inventory_content=$(cat <<-EOF
[haproxy]
haproxy1 ansible_host=$haproxy_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem docker_image=pablop115/haproxy name=haproxy ports=80:80 

[web_servers]
client ansible_host=$frontend_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem docker_image=pablop115/client name=client ports=80:80
auth ansible_host=$auth_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/auth name=auth ports=3001:3001
discounts ansible_host=$discount_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/discounts name=discounts ports=3002:3002
items ansible_host=$items_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/items name=items ports=3003:3003

[loadbalancers]
auth-loadbalancer dns=$auth_loadbalancer_ip
discount-loadbalancer dns=$discount_loadbalancer_ip
items-loadbalancer dns=$items_loadbalancer_ip

[web_servers:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ../key.pem -W %h:22 ubuntu@${haproxy_ip}" -o ConnectTimeout=3000'

EOF
            )

            cd ..

            echo "$inventory_content" >> "$ansible_dir/inventory"

            echo -e "\n Inventory generated"

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue
            ;;
        "2")
            echo -e "Pinging hosts"

            cd "$ansible_dir"
            ansible all -m ping

            cd ..

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue
            ;;
        "3")
            echo -e "Running setup playbook"

            cd "$ansible_dir"
            ansible-playbook setup.yml

            cd ..

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue
            ;;
        "0")
            echo -e "\n\n Exiting . . ."
            ;;
        esac
    done
}

loop_value="9"

while [ "$loop_value" != "0" ]
do
    menu

    read user_reply
    
    loop_value=$user_reply

    echo -e "\n\n"          

    case $user_reply in
    "1")
        terraform_function
        ;;
    "2")
        ansible_function
        ;;
    "0")
        echo -e "\n\n Exiting . . ."
        ;;
    esac
done    

echo "exited"
