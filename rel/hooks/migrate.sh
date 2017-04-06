# rel/hooks/migrations
#!/bin/sh

echo "Running migrations"
bin/bird command Elixir.Bird.ReleaseTasks migrate
