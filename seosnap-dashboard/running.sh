# create log folder at root
echo 'Create logs'
mkdir logs

echo 'Install requirements'
pip3 install -r requirements.txt

echo 'Add nameserver'
FILE_NAME='hello.txt'

HAVE_GG=$(cat $FILE_NAME | grep nameserver)

if [ -z "$HAVE_GG" ]; then
  echo nameserver 8.8.8.8 >>$FILE_NAME
else
  echo "\$var is NOT empty"
fi

echo 'run'
make serve
