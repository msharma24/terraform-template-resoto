locals {
  user_data = <<-EOT
  #!/bin/bash
  echo "[INFO] Running init script..."
  touch >> /tmp/test.txt
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

  mkdir -p /home/ec2-user/resoto/dockerV2
  cd /home/ec2-user/resoto
  curl -o docker-compose.yaml https://raw.githubusercontent.com/someengineering/resoto/2.3.2/docker-compose.yaml
  curl -o dockerV2/prometheus.yml https://raw.githubusercontent.com/someengineering/resoto/2.3.2/dockerV2/prometheus.yml
  docker-compose up -d

  sudo chown -R ec2-user:ec2-user /home/ec2-user/resoto
  echo "[INFO] Running init script..."
  EOT
}
