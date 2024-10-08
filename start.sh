#!/bin/bash

function menu(){
    clear
    echo "1 - terraform apply"
    echo "2 - terraform destroy"
    echo "3 - generate ansible inventory"
    echo "4 - ping ansible inventory"
    echo "5 - run ansible playbook"
    echo "0 - exit"
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
        echo "Running terraform apply. . . "

        cd terraform
        terraform apply -auto-approve

        cd ..

        echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
        read continue
        ;;
    "2")
        echo "Running terraform destroy. . . "

        cd terraform
        terraform destroy -auto-approve

        cd ..

        echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
        read continue
        ;;
    "3")
        echo "Cleaning inventory file"
        >ansible/inventory

        echo -e "\nGenerating ansible invetory. . . "

        cd terraform

        haproxy_ip=$(terraform output -raw haproxy)
        frontend_ip=$(terraform output -raw frontend)
        auth_ip=$(terraform output -raw auth)
        discount_ip=$(terraform output -raw discount)
        items_ip=$(terraform output -raw items)

        echo -e "\n Gathering IPs"
        echo "haproxy   : $haproxy_ip"
        echo "frontend  : $frontend_ip"
        echo "auth      : $auth_ip"
        echo "discount  : $discount_ip"
        echo "items     : $items_ip"

        echo -e "\n Generating ansible inventory file"
        inventory_content=$(cat <<-EOF
            [haproxy]
            haproxy1 ansible_host=$haproxy_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem docker_image=pablop115/haproxy name=haproxy ports=80:80 

            [web_servers]
            client ansible_host=$frontend_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem docker_image=pablop115/client name=client ports=80:80
            auth ansible_host=$auth_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/auth name=auth ports=3001:3001
            discounts ansible_host=$discount_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/discounts name=discounts ports=3002:3002
            items ansible_host=$items_ip ansible_user=ubuntu ansible_ssh_private_key_file=../key.pem  docker_image=pablop115/items name=items ports=3003:3003

            [web_servers:vars]
            ansible_ssh_common_args='-o ProxyCommand="ssh -i ../key.pem -W %h:22 ubuntu@${haproxy_ip}" -o ConnectTimeout=3000'

EOF
        )

        cd ..

        echo "$inventory_content" >> ansible/inventory

        echo -e "\n Inventory generated"

        echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
        read continue
        ;;
    "4")
        echo -e "Pinging hosts"

        cd ansible
        ansible all -m ping

        cd ..

        echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
        read continue
        ;;
    "5")
        echo -e "Runnign playbook"

        cd ansible
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

echo "exited"
