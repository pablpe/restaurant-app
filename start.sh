#!/bin/bash

#directories
# this gets the current directory for the script (it's not used, but it's here if we need it)
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# terraform folder
terraform_dir="terraform"

# ansioble folder
ansible_dir="ansible"


#Menu prints
function menu(){
    clear #Clears the loop, so when you go back to the menu you always have a clean terminal
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


#Functions that execute the options selected in the menu
function terraform_function(){

	#Default value, can be anything as long as it's not 0 (exit value), if it reaches 0 it will exit the loop and thus exiting the menu
    terraform_loop="9"
	
	
    while [ "$terraform_loop" != "0" ] #if it reaches 0 it leaves the loop
    do
        terraform_menu #Calls the terraform menu function
        read user_choice #Reads user input (choice)

        terraform_loop=$user_choice #terraform_loop acquires the value of the user input to see if it's 0 for the loop validation

        echo -e "\n\n"

        case $user_choice in #Selects what to execute based on user choices
        "1")
            echo "Cleaning terraform directories" #Prints what we're doing

            cd "$terraform_dir" #Changes working directory to the terraform directory defined above

            rm -rf .terraform .terraform.lock.hcl terraform.tfstate.backup #removes all terraform files, effectively cleaning the repo

            echo -e "\n Cleaning done" #Job done

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<" #Letting the user know he has to click anything to go back to menu
            read continue #Reads user input, does not need validation as it can be any key (it isn't used as anything else, just for the user to recognize the job is done)

            cd .. #Changes the directory back

            ;;
        "2") #It is mostly the same for the other options, so I will not comment further
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

#Loop works the same as the previous one and the main menu one, so I will just comment what our menu options do
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
            echo "Cleaning inventory file" #let us know what we're doing
            >ansible/inventory #Wipes ansible inventory file

            echo -e "\nGenerating ansible invetory . . . " # #Lets us know what we're doing

            cd "$terraform_dir" #changes directory to terraform directory to get the outputs

			#Getting the outputs
            haproxy_ip=$(terraform output -raw haproxy)
            frontend_ip=$(terraform output -raw frontend)
            auth_ip=$(terraform output -raw auth)
            discount_ip=$(terraform output -raw discount)
            items_ip=$(terraform output -raw items)
            auth_loadbalancer_ip=$(terraform output -raw auth-loadbalancer)
            discount_loadbalancer_ip=$(terraform output -raw discount-loadbalancer)
            items_loadbalancer_ip=$(terraform output -raw items-loadbalancer)

			#Pringint the outputs
            echo -e "\n Gathering IPs"
            echo "haproxy       : $haproxy_ip"
            echo "frontend      : $frontend_ip"
            echo "auth          : $auth_ip"
            echo "discount      : $discount_ip"
            echo "items         : $items_ip"
            echo "loadbalancer - auth  : $auth_loadbalancer_ip"
            echo "loadbalancer - discount : $discount_loadbalancer_ip"
            echo "loadbalancer - items : $items_loadbalancer_ip"

			#This needs to be indented all the way to the left or the EOF will not register it and it will break the code
			#This is the ansible inventory file content built in this script, that will then be inserted into the inventory file
			#If you want to change the inventory file, do it here
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
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
EOF
            )

            cd .. #Changes directory to main folder

            echo "$inventory_content" >> "$ansible_dir/inventory" #Inserts the inventory content above to the inventory file

            echo -e "\n Inventory generated" #Lets us know the job has been completed

            echo -e "\n >>>> PRESS ANY KEY TO CONTINUE <<<<"
            read continue
            ;;
        "2") #The other options just execute commands
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
            ansible-playbook setup.yml #you can change the playbook here, should be a variable but I could not be bothered

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

#Main menu
#How it works?
#it creates a loop where the menu is always printed at the beginning

#Default value, can be anything as long as it's not 0 (exit value), if it reaches 0 it will exit the loop and thus exiting the menu
loop_value="9"

while [ "$loop_value" != "0" ] #if it reaches 0 it leaves the loop
do
    menu #Prints the main menu

    read user_reply #Reads user input (choice)
    
    loop_value=$user_reply #loop_value acquires the value of the user input to see if it's 0 for the loop validation

    echo -e "\n\n"        #Just spacing, -e means it can read \n which is basically an Enter

    case $user_reply in  #Switch case to examine user's choices
    "1")
        terraform_function #Calls the terraform function which contains the terraform submenu and the actual commands
        ;;
    "2")
        ansible_function #Calls the ansible function which contains the ansible submenu and the actual commands
        ;;
    "0")
        echo -e "\n\n Exiting . . ." #Just printing exiting..., -e means it can read \n which is basically an Enter
        ;;
    esac
done    

echo "exited" #Informs the user he has left the loop
