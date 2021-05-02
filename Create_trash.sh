#!/bin/bash
#original: wuguangke
#Write by afei

mkdir -p ~/.trash
cat >> ~/.bashrc << EOF
alias rm=trash  
alias r=trash  
alias rmlist='ls ~/.trash'
alias unrm=undelfile

undelfile()
{
  mv -i ~/.trash/$@ ./
}

trash()
{
  mv $@ ~/.trash/
}

cleartrash()
{
read -p "clear sure?[n]" confirm
[ $confirm == 'y' ] || [ $confirm == 'Y' ] && /usr/bin/rm -rf ~/.trash/*
}
EOF

source ~/.bashrc