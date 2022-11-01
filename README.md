### Run Drupal Commerce Kickstart 3 in a Docker container ###

1. create a project directory and copy the compose.yaml, install.yaml and Dockerfile into it
```
mkdir testdrupal
cd testdrupal
<copy the compose.yaml, install.yaml and Dockerfile here>
```
2. create image from Dockerfile
```
sudo docker build -t mihaimiculescu/drupal_commerce_kickstart_3 .
```
3. start up the containers
```
sudo docker compose -f install.yaml up -d
```
3a. Run `sudo docker ps` and note the name of the MariaDb container

4. navigate to localhost and run the installer `install.php`
Check the MariaDb option. When asked about the database user and password, enter `drupal` for both. Also, under `Advanced`, replace the default `localhost` with the name of the container noted down at 3a.

5. Back to the terminal, copy container folders of interest on local filesystem
```
sudo docker cp testdrupal-drupal-1:/var/www/html/modules ./modules
sudo docker cp testdrupal-drupal-1:/var/www/html/profiles ./profiles
sudo docker cp testdrupal-drupal-1:/var/www/html/themes ./themes
sudo docker cp testdrupal-drupal-1:/var/www/html/sites ./sites
sudo docker cp testdrupal-drupal-1:/opt/drupal/private ./private
sudo chown -R www-data:www-data modules profiles themes sites private
```
6. Restart the combination with complete config
```
sudo docker compose stop
sudo docker compose up -d
```
#### Usage ####

- To run drush or composer commands:

First, you need to get inside the Drupal container. Run `sudo docker ps` and get the name of the Drupal container. 
Then, to get inside the container run `sudo docker exec - ti <the name of the Drupal container> bash`
Once inside the container, you can run drush and composer commands. You don't need to prefix anything with `sudo` anymore.

- Every change you make in the files on the local filesystem is instantly propagated in the corresponding file(s) inside the container.

- To start over again, simply run
``` sudo docker compose down ```. This will erase all your containers. 
Then, clean up your folder, leaving only the compose.yaml, install.yaml and Dockerfile files. 
Then, go to step 3.

- ```phpmyadmin``` is available at ```localhost:8080```. To log in, use ```drupal``` for both username and password.

- Once you're done and ready for production, simply convert your Drupal container to an image and move it to the production server.
