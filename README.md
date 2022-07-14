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
If and onky if you use an arm64 machine, you can pull the image from the hub
```
sudo docker pull mihaimiculescu/drupal_commerce_kickstart_3
```
otherwise you need to build the image. 

3. start up the containers
```
sudo docker compose -f install.yaml up -d
```
4. navigate to localhost and run the installer `install.php`
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
