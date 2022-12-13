PID=$(ps -ef | grep hexo | grep -v grep | awk '{ print $2 }')
if [ -z "$PID" ]
then
  echo Application is already stopped
else
  echo kill $PID
      echo backend has stopped
  kill -9 $PID
fi

npx hexo generate
nohup npx hexo server -p 2550 &