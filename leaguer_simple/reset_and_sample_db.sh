rake db:reset
rake db:populate
RAILS_PID=$(cat tmp/pids/server.pid 2> /dev/null)
if [ ! -z "$RAILS_PID" -a "$RAILS_PID" != " " ]; then
    kill -9 $RAILS_PID
fi
rails s -p 3135 &
