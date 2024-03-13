### Run Drupal Commerce Kickstart 3 in a Docker container ###

This guide assumes that your `localhost`'s ports 80 and 8080 are already taken by other apps running.
Therefore, ports 81 and 8082 are used instead.

1. create a project directory and copy the compose.yaml, install.yaml and Dockerfile into it
```
mkdir testdrupal
cd testdrupal
<copy the compose.yaml, install.yaml and Dockerfile here>
```
2. create image from Dockerfile
```
sudo docker build -t demo_commerce_kickstart_3 .
```
3. start up the containers
```
sudo docker compose -f install.yaml up -d
```
4. navigate to `localhost:81` and run the installer.
Check the MariaDb option. When asked about the database name, user and password, enter `drupal` everywhere. Also, under `Advanced`, replace the default `localhost` with `mariadbdemo`.
4.1 Later on during the installation process, make sure tu check the option to install the complete store demo, by checking the box when presented.

6. Back to the terminal, copy container folders of interest on local filesystem
```
sudo docker cp kickstartdemo:/opt/drupal/web/modules ./modules
sudo docker cp kickstartdemo:/opt/drupal/web/profiles ./profiles
sudo docker cp kickstartdemo:/opt/drupal/web/themes ./themes
sudo docker cp kickstartdemo:/opt/drupal/web/sites ./sites
sudo docker cp kickstartdemo:/opt/drupal/private ./private
sudo chown -R www-data:www-data modules profiles themes sites private
```
6. Restart the combination with complete config
```
sudo docker compose stop
sudo docker compose up -d
```
#### Usage ####

- To run `drush` or `composer` commands:

First, you need to get inside the Drupal container. Run `sudo docker exec - ti kickstartdemo bash`
Once inside the container, you can run drush and composer commands. You don't need to prefix anything with `sudo` anymore.

- Every change you make in the files on the local filesystem is instantly propagated in the corresponding file(s) inside the container.

- To start over again, simply run
``` sudo docker compose down ```. This will erase all your containers. 
Then, clean up your folder, leaving only the compose.yaml, install.yaml and Dockerfile files. 
Then, go to step 3.

- ```phpmyadmin``` is available at ```localhost:8082```. To log in, use ```drupal``` for both username and password.
