<h1>Restaurant App</h1>
<h2>Architecture</h2>
<p>Image goes here</p>

<h2>Deployment</h2>
<h3>Menu</h3>
<p/>This application comes with a menu to help you deploy and setup your resources easier.<p/>
<p>It's a very simple menu that lets you run terraform flow and a few ansible commands (already setup) without much imput.</p>
<p>You can start the menu by opening the terminal inside the main project folder and running the command "<i>./start.sh</i></p>

<h3>Locally</h3>
<h4>Docker</h4>
<p>In the local version of the application, you just need to run the "<i>docker compose up</i>" command.</p>
<p>This command will automatically pull the images create and run the containers necessary for the app to run.</p>
<p>To verify if the app is running, you can access localhost via a web browser of your choosing, make sure not to use https.</p>
<p>If you also want to check the backend, you can attach /api/[backend_name] to the localhost url</p>


<h3>Remote</h3>
<p>To install the app remotely is a bit more complicated, it requires an aws account with S3, DynamoDB, EC2, and VPC permissions. You will also need terraform and ansible</p>
<h4>Terraform flow</h4>
<p>To create the necessary resources to handle our application you need to run the terraform flow commands inside the terraform directory in the project</p>
<p>These commands consist of:</p>
<ul>
  <li><b>terraform init: </b> Initializes the terraform repository</li>
  <li><b>terraform fmt: </b> Formats the .tf files to fit terraform standards</li>
  <li><b>terraform validate: </b> Checks for syntax errors and validates your terraform build</li>
  <li><b>terraform plan: </b> Plans the resources that will be created</li>
  <li><b>terraform apply: </b> Applies the plan and creates every resource specified including a terraform state file</li>
  <li><b>terraform destroy: </b> Deestroys the resources created during the terraform apply command</li>
</ul>
<br>
<p>You can also perform these tasks using the menu. Including a new option to wipe your terraform repository</p>

<h4>Ansible</h4>
<p>Now that we have our resources, we need to setup them up so they can work properly and how we want them. To do this we will run ansible commands (again, these can be used via menu)</p>
<p>The first thing we need to do is get the IPs for the haproxy ec2, the client ec2, and the DNS ips of the loadbalancers. These can be obtained by the outputs when executing terraform apply</p>
<p>Then, we need to fill the ansible inventory file, called inventory, with those IPs, and create the necessary hosts. These 2 steps can be done with the menu by selecting the ansible option, and then selecting the Generate ansible inventory file</p>

<br>
<p>After that is done, it is now time to test if the resources are contactable. To do this we simply run the command "<i>ansible all -m ping</i>". </p>
<p>If the loadbalancers give errors, it is of no issue, since we do not use those hosts. We just want the IPs registered to use them as variable in the haproxy.cfg file.</p>
<p>This step can also be done in the menu, and might need to run multiple times untill all the hosts work properly.</p>

<br>
<p>Finally we are ready to run our ansible playbook. To do this you need to run the command "<i>ansible-playbook setup.yml</i>". You can also do this in the menu.</p>
<p>After executing this command, your application should work. To test this insert the public ip of the haproxy machine (the one in your ansible inventory file) in the browser (no https) and you should have the application page.</p>
<p>To go the api's, similarly to the local instalation, you run "http:[public haproxy ip]/api/[back_end name] and you should see "[backend name] server up!"</p>

