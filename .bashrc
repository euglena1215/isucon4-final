if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f /home/isucon/env_variables.sh ]; then
  source /home/isucon/env_variables.sh
fi
