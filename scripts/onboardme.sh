#!/bin/sh

GREEN='\033[0;32m'
LIGHTBLUE='\033[0;94m'
NC='\033[0m'

now="$(date +'%Y-%m-%d--%H-%M-%S')"

NODE_VERSION=v5.10.1
DRUSH_VERSION=8.1

echo "${LIGHTBLUE}"
cat <<EOF

  _  _        _    _ _    ____  _       _ _        _
 | || |      / \  | | |  |  _ \(_) __ _(_) |_ __ _| |
 | || |_    / _ \ | | |  | | | | |/ _  | | __/ _  | |
 |__   _|  / ___ \| | |  | |_| | | (_| | | || (_| | |
    |_|   /_/   \_\_|_|  |____/|_|\__, |_|\__\__,_|_|
                                  |___/

EOF
echo "${NC}"

echo "${LIGHTBLUE}#######################################${NC}"
echo "${LIGHTBLUE} ADD VARS AND CONFIG TO ./bash_profile ${NC}"
echo "${LIGHTBLUE}#######################################${NC}"
grep -q -F '.composer/vendor/bin' ~/.bash_profile || echo '\n# ADDED VIA ONBOARDING \nexport PATH="$HOME/.composer/vendor/bin:$PATH"' | sudo tee -a  ~/.bash_profile > /dev/null 2>&1
grep -q -F 'APPS_PATH=~/Sites' ~/.bash_profile || echo '\n# ADDED VIA ONBOARDING \nexport APPS_PATH=~/Sites' | sudo tee -a  ~/.bash_profile > /dev/null 2>&1
grep -q -F 'This loads NVM' ~/.bash_profile || echo '\n# ADDED VIA ONBOARDING \n[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM' | sudo tee -a  ~/.bash_profile > /dev/null 2>&1
grep -q -F '127.0.0.1 drupal.docker' /etc/hosts || echo '\n# ADDED VIA ONBOARDING \n127.0.0.1 drupal.docker' | sudo tee -a /etc/hosts > /dev/null 2>&1
source ~/.bash_profile

echo "${LIGHTBLUE}####################${NC}"
echo "${LIGHTBLUE}INSTALL DEPENDENCIES${NC}"
echo "${LIGHTBLUE}####################${NC}"

# #
# # Check if Composer is installed
# #
which -s composer || curl --progress-bar -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# #
# # Check if SSH-COPY-ID is installed
# # SSH-COPY-ID for OSX we will need later to ssh between containers
# #
which -s ssh-copy-id || curl --progress-bar -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh

cp ~/infra/drupaldev-docker/settings/example-nginx.txt ~/infra/drupaldev-docker/nginx.env
cp ~/infra/drupaldev-docker/settings/example-mysql.txt ~/infra/drupaldev-docker/mysql.env
source  ~/.bash_profile

# # #
# # # Pull and start containers
# # #
docker-compose up -d

# launch in preferred browser
python -mwebbrowser http://localhost:8983/solr/#/SITE
python -mwebbrowser http://localhost:4444/grid/console
python -mwebbrowser http://localhost:1080

