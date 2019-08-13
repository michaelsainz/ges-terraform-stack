#!/bin/bash -e
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/log.out 2>&1

INSTANCE="${role}"        # Master|Replica - of GHE
echo "GES-SCRIPT: Value of INSTANCE=$INSTANCE"

if [ $INSTANCE == "replica" ] || [ $INSTANCE == "Replica" ] || [ $INSTANCE == "REPLICA" ]; then
  CONFIGURE_REPLICA="True"  # True|False - to set up replica server
  MASTER_IP="${primary_ip}"      # IP Address of the master node
  echo "GES-SCRIPT: Value of MASTER_IP=$MASTER_IP"
else
  CONFIGURE_REPLICA="False"
  MASTER_IP=$(ip address | grep eth0 | grep inet | grep -Eo "(([0-9]{1,3})\.){3}([0-9]{1,3}){2}" | head -n 1)
  echo "GES-SCRIPT: Value of MASTER_IP=$MASTER_IP"
fi

GHE_USER_NAME="user"                    # User name to create in GHE
echo "GES-SCRIPT: Value of GHE_USER_NAME=$GHE_USER_NAME"
GHE_PASSWORD="${ges_mgmt_password}"                # Password for that user
echo "GES-SCRIPT: Value of GHE_PASSWORD=$GHE_PASSWORD"
GHE_LICENSE_FILE="/tmp/github-enterprise.ghl"   # License file to plug in
echo "GES-SCRIPT: Value of GHE_LICENSE_FILE=$GHE_LICENSE_FILE"
SETTINGS_FILE_PATH="/tmp/ges-settings.json"     # Path to GHE config json
echo "GES-SCRIPT: Value of SETTINGS_FILE_PATH=$SETTINGS_FILE_PATH"
TEMPDIR='/tmp/XXXXXXXXXXXXX'              # Directory to hold info while creating
echo "GES-SCRIPT: Value of TEMPDIR=$TEMPDIR"
AWS_IP='169.254.169.254'                  # IP to AWS endpoint
echo "GES-SCRIPT: Value of AWS_IP=$AWS_IP"
REGION=$(sudo curl -s http://$AWS_IP/latest/meta-data/placement/availability-zone | sed 's/.$//') # Region in AWS
echo "GES-SCRIPT: Value of REGION=$REGION"
INSTANCE_IP=$(ip address | grep eth0 | grep inet | grep -Eo "(([0-9]{1,3})\.){3}([0-9]{1,3}){2}" | head -n 1)    # IP or connection string to GHE Instance
echo "GES-SCRIPT: Value of INSTANCE_IP=$INSTANCE_IP"
PUBLIC_HOSTNAME="${public_hostname}"
echo "GES-SCRIPT: Value of PUBLIC_HOSTNAME=${public_hostname}"
SLEEP_TIME='6m'   # Amount of time for replica to sleep before trying to configure itself
echo "GES-SCRIPT: Value of SLEEP_TIME=$SLEEP_TIME"

echo "Downloading license file from: ${license_url}"
wget ${license_url}
mv ges-license.ghl /tmp/github-enterprise.ghl

ValidateMasterReady() {
  echo "-----------------------------------------------------"
  echo "GES-SCRIPT: Validating Instance is ready for configuration"
  # Set Sleep seconds
  SLEEP_SECONDS=15
  
  for ((n=0; n<10; n++)); do
    echo "GES-SCRIPT: Current iteration of loop - $n"
    if curl -iks https://localhost:8443/setup/api/configcheck | grep -q 'Access forbidden, please upload' ; then
      echo "GES-SCRIPT: Instance is ready for configuration"
      break
    else
      echo "GES-SCRIPT: Waiting additional $SLEEP_SECONDS seconds for instance to respond..."
    fi
    sleep $SLEEP_SECONDS
  done
  echo "GES-SCRIPT: Out of ValidateMasterReady function loop"
}
ValidateMasterConfigured() {
  echo "-----------------------------------------------------"
  echo "Validating Master instance is configured and ready"
  
  echo "GES-SCRIPT: Sleeping for 30 seconds..."
  SLEEP_SECONDS=30
  
  for ((n=0; n<10; n++)); do
    echo "GES-SCRIPT: Number of times in CURL loop - $n"
    echo "GES-SCRIPT: Calling command - curl -iks https://$GHE_USER_NAME:$GHE_PASSWORD@$INSTANCE_IP/api/v3/status | grep -iq \"github lives\""
    curl -iks https://$GHE_USER_NAME:$GHE_PASSWORD@$INSTANCE_IP/api/v3/status | grep -iq "github lives"

    if [ $? -eq 0 ]; then
      echo "Master instance is up and has been configured"
      #break
    else
      echo "Waiting additional $SLEEP_SECONDS seconds for Master instance to finish configuration"
    fi
    sleep $SLEEP_SECONDS
  done
}
InstallLicenseAndAdminPassword() {
  echo "-----------------------------------------------------"
  echo "GES-SCRIPT: Setting the License file and Admin Password"

  echo "GES-SCRIPT: Calling command - curl -isk -X POST https://localhost:8443/setup/api/start -F license=@$GHE_LICENSE_FILE -F "password=$GHE_PASSWORD" | grep '202 Accepted'"
  CURL_CMD=$(curl -isk -X POST https://localhost:8443/setup/api/start -F license=@$GHE_LICENSE_FILE -F "password=$GHE_PASSWORD" | grep '202 Accepted')

  if [ $? -eq 0 ] ; then
    echo "GES-SCRIPT: Machine successfully took License and Admin credentials"
  else
    echo "GES-SCRIPT: ERROR! Machine Failed to take License or Admin credentials!"
    exit 1
  fi
}
ConfigureMasterInstance() {
  # Set sleep seconds
  SLEEP_SECONDS=10

  sleep $SLEEP_SECONDS

  echo "-----------------------------------------------------"
  echo "GES-SCRIPT: Passing configuration file to the Master instance"
  echo "GES-SCRIPT: This could take several moments..."

  CURL_CMD=$(curl -Lk -X PUT https://api_key:$GHE_PASSWORD@$MASTER_IP:8443/setup/api/settings --data-urlencode "settings=`cat $SETTINGS_FILE_PATH`")

  echo "-----------------------------------------------------"
  echo "GES-SCRIPT: Configuring the Master instance"
  echo "GES-SCRIPT: This could take several moments..."
  
  CURL_CMD=$(curl -ik -XPOST https://api_key:$GHE_PASSWORD@$MASTER_IP:8443/setup/api/configure)

  SLEEP_SECONDS=30
  
  sleep $SLEEP_SECONDS

  # Flag for if success found with configuration
  SUCCESS_FLAG=0

  for ((n=0; n<20; n++)); do
    if curl -ik https://api_key:$GHE_PASSWORD@$INSTANCE_IP:8443/setup/api/configcheck | grep 'status":"success' ; then
      echo "GES-SCRIPT: GHE Master instance Configuration Success"
      SUCCESS_FLAG=1
      break
    else
      echo "GES-SCRIPT: Configuration still in process..."
      sleep $SLEEP_SECONDS
    fi
  done

  if [ $SUCCESS_FLAG -eq 0 ]; then
    echo "GES-SCRIPT: ERROR! Master instance never responded with success!"
    exit 1
  fi

  echo "GES-SCRIPT: Configuring Let's Encrypt/ACME service"
  ACME_CMD=$(ghe-ssl-acme -e)
  sleep 3m
}
CreateInitialUser() {
  echo "-----------------------------------------------------"
  echo "GES-SCRIPT: Configuring the initial user"

  echo "GES-SCRIPT: Calling command - curl -iskL https://$INSTANCE_IP/join | grep 'Status: 200 OK'"
  curl -iskL https://$INSTANCE_IP/join | grep 'Status: 200 OK'

  echo "GES-SCRIPT: Calling command - mkdir -p $TEMPDIR"
  mkdir -p $TEMPDIR

  echo "GES-SCRIPT: Command - curl -k -v -L -c $TEMPDIR/cookies https://$INSTANCE_IP/login >$TEMPDIR/github-curl.out"
  curl -k -v -L -c $TEMPDIR/cookies https://$INSTANCE_IP/login >$TEMPDIR/github-curl.out

  authenticity_token=$(grep 'name="authenticity_token"' $TEMPDIR/github-curl.out | head -1 | sed -e 's/.*value="\([^"]*\)".*/\1/')
  echo "GES-SCRIPT: Value of variable authenticity_token - $authenticity_token"

  curl -X POST -k -v -b $TEMPDIR/cookies -c $TEMPDIR/cookies -F "authenticity_token=$authenticity_token" -F "user[login]=$GHE_USER_NAME" -F "user[email]=$GHE_USER_NAME@test" -F "user[password]=$GHE_PASSWORD" -F "user[password_confirmation]=$GHE_PASSWORD" -F "source_label=Detail Form" https://$INSTANCE_IP/join >$TEMPDIR/github-curl.out 2>&1
  cat $TEMPDIR/github-curl.out
  grep "< Set-Cookie: logged_in=yes;" $TEMPDIR/github-curl.out
  echo "GES-SCRIPT: Successfully set initial user to GHE instance"
  echo "GES-SCRIPT: Removing temp dir created during install"
  rm -rf $TEMPDIR
}
ConfigureReplica() {
  echo "GES-SCRIPT: Configuring Replica Server"
  
  echo "GES-SCRIPT: Executing command: ghe-repl-setup $MASTER_IP"
  ghe-repl-setup $MASTER_IP

  if [ $? -eq 0 ]; then
  echo "GES-SCRIPT: Command (ghe-repl-setup $MASTER_IP) was successful"

  else
    echo "GES-SCRIPT: Command (ghe-repl-setup $MASTER_IP) didn't exit cleanly (Exit code: $? was returned)"
    echo "GES-SCRIPT: Output of ghe-repl-setup:\n $GES_CMD"
  fi
  
  #  echo "GES-SCRIPT: getting RSA info and path from Handshake"
  #  RSA_FILE=$(find /home/admin/.ssh -name '*.pub')

  #  if [ -f $RSA_FILE ]; then
  #    echo "GES-SCRIPT: Found RSA file"
  #  else
  #    echo "GES-SCRIPT: ERROR! Failed to find RSA FILE!"
  #    exit 1
  #  fi
  #  
  #  CURL_CMD=$(curl -ik -XPOST https://api_key:$GHE_PASSWORD@$MASTER_IP:8443/setup/api/settings/authorized-keys -F authorized_key=@$RSA_FILE)
  #
  #  if [ $? -eq 0 ]; then
  #    echo "GES-SCRIPT: GHE Replica server key added Successfully"
  #  else
  #    echo "GES-SCRIPT: ERROR! Failed to configure Replica Server key!"
  #    exit 1
  #  fi
  #  
  #  ghe-repl-setup $MASTER_IP
  #  echo "GES-SCRIPT: Exit code of ghe-repl-setup $MASTER_IP is - $?"
  #  if [ $? -eq 0]; then
  #    echo "GHE Replica server configured Successfully"
  #  else
  #    echo "ERROR! Failed to configure Replica Server!"
  #    exit 1
  #  fi
  #  sleep 45
  #  ghe-repl-start
  #
  #  if [ $? -eq 0 ]; then
  #    echo "GHE Replica server Started Successfully"
  #    exit 0
  #  else
  #    echo "ERROR! Failed to Start Replica Server!"
  #    exit 1
  #  fi
}

echo "GES-SCRIPT: Determining if GES instance is a master or a replica"
if [ $INSTANCE == "master" ] || [ $INSTANCE == "Master" ] || [ $INSTANCE == "MASTER" ]; then
  
  echo "GES-SCRIPT: GES instance is a master, calling ValidateMasterReady function"
  ValidateMasterReady
  
  echo "GES-SCRIPT: Calling InstallLicenseAndAdminPassword function"
  InstallLicenseAndAdminPassword

  echo "GES-SCRIPT: Calling ConfigureMasterInstance function"
  ConfigureMasterInstance

  echo "GES-SCRIPT: Calling CreateInitialUser function"
  CreateInitialUser
  
else
  # See if the replica needs to be configured #
  if [ $CONFIGURE_REPLICA == "true" ] || [ $CONFIGURE_REPLICA == "TRUE" ] || [ $CONFIGURE_REPLICA == "True" ]; then
    
    echo "GES-SCRIPT: This is the Replica Node, setting up basic configuration"

    echo "GES-SCRIPT: Sleeping for $SLEEP_TIME to allow master to be configured"
    sleep $SLEEP_TIME
    
    echo "GES-SCRIPT: Calling ValidateMasterConfigured function"
    ValidateMasterConfigured
    
    echo "GES-SCRIPT: Calling ConfigureReplica function"
    ConfigureReplica
    
  else
    # Replica set to not be configured #
    echo "Replica server set to NOT be configured"
    echo "Exiting configuration"
    exit 0
  fi
fi