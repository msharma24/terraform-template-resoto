locals {
  user_data_docker = <<-EOT
  #!/bin/bash
  echo "[INFO] Running init script..."
  touch >> /tmp/user_data_docker.txt
  sudo yum update -y
  sleep 5;
  sudo amazon-linux-extras install docker -y
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo service docker start
  chkconfig docker on

  sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

  sudo chmod +x /usr/local/bin/docker-compose

  docker-compose version

  echo "[INFO] Configuring Resoto shell"
  mkdir -p /home/ec2-user/resoto/dockerV2
  cd /home/ec2-user/resoto
  curl -o docker-compose.yaml https://raw.githubusercontent.com/someengineering/resoto/2.3.2/docker-compose.yaml
  curl -o dockerV2/prometheus.yml https://raw.githubusercontent.com/someengineering/resoto/2.3.2/dockerV2/prometheus.yml
  docker-compose up -d

  sudo chown -R ec2-user:ec2-user /home/ec2-user/resoto
  EOT

  user_data_python_pip = <<-EOT
  #!/bin/bash
  touch >> /tmp/user_data_python_pip.txt
  sudo yum update -y
  sleep 5;
  sudo yum groupinstall "Development Tools" -y
  sudo yum install openssl11 openssl11-devel  libffi-devel bzip2-devel wget -y
  gcc --version
  wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
  tar -xf Python-3.10.4.tgz
  cd Python-3.10.4/
  ./configure --enable-optimizations
  make -j $(nproc)
  sudo make altinstall
  python3.10 --version
  mkdir -p ~/resoto
  cd ~/resoto
  $(which python3.10) -m venv resoto-venv
  source resoto-venv/bin/activate
  python -m ensurepip --upgrade
  pip install -U resotocore resotoworker resotometrics resotoshell resoto-plugins
  # Generate two random passphrases. One to secure the graph database and one to secure resotocore with.
  echo $(LC_ALL=C tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c 20) > .graphdb-password
  echo $(LC_ALL=C tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c 20) > .pre-shared-key
  chmod 600 .graphdb-password .pre-shared-key

  mkdir -p ~/resoto/arangodb ~/resoto/data
  cd ~/resoto
  curl -L -o arangodb3.tar.gz https://download.arangodb.com/arangodb39/Community/Linux/arangodb3-linux-3.9.1.tar.gz
  tar xzf arangodb3.tar.gz --strip-components=1 -C arangodb
  rm -f arangodb3.tar.gz
  arangodb/bin/arangod --database.directory ~/resoto/data > /dev/null &

  graphdb_password=$(< ~/resoto/.graphdb-password)
  pre_shared_key=$(< ~/resoto/.pre-shared-key)
  source ~/resoto/resoto-venv/bin/activate

  resotocore --graphdb-password "$graphdb_password" --graphdb-server http://localhost:8529 --psk "$pre_shared_key" > /dev/null &
  resotoworker --resotocore-uri https://localhost:8900 --psk "$pre_shared_key" > /dev/null &
  resotometrics --resotocore-uri https://localhost:8900 --psk "$pre_shared_key" > /dev/null &


  source ~/resoto/resoto-venv/bin/activate
  echo "Run resh --resotocore-uri https://localhost:8900 --psk "$pre_shared_key""

  EOT
}
