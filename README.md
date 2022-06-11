### Run Drupal Commerce Kickstart 3 in a Docker container ###

1. create a project directory and copy the compose.yaml, install.yaml and (optionally) Dockerfile into it
```
mkdir testdrupal
cd testdrupal
<copy the compose.json and Dockerfile here>
```
2. create image from Dockerfile
```
sudo docker build -t mihaimiculescu/drupal_commerce_kickstart_3 .
```
or pull it from the hub
```
sudo docker pull mihaimiculescu/drupal_commerce_kickstart_3
```
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
sudo chown -R www-data:www-data modules profiles themes sites
```
6. Restart the combination with complete config
```
sudo docker compose stop
sudo docker compose up -d
sudo docker exec -ti testdrupal-drupal-1 bash
mkdir private
chown -R www-data:www-data private
exit
```
