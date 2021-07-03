echo "make cache and logs"
mkdir cache logs

echo "install requirements"
pip3 install -r requirements.txt

echo "add listen port for cache server"
FILE_NAME='.env'
LISTEN_PORT=5000

HAVE_LISTENPORT=$(cat $FILE_NAME | grep "LISTEN_PORT=$LISTEN_PORT")

if [ -z "$HAVE_LISTENPORT" ]; then
  echo "LISTEN_PORT=$LISTEN_PORT" >>$FILE_NAME
fi

echo "run"
bash start.sh
