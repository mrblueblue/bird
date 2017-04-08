# Bird

Craiglist apartment scraper and slackbot written in Elixir

## Running

Before running, create a `.env` file with your Slack API Token:

```
export SLACK_TOKEN="<TOKEN>"
```

Then run:

```bash
source .env
```

### Development

```bash
mix deps.get
iex -S mix
```

### Production

```bash
mix deps.get
mix release --verbose --env=prod
rel/bird/bin/bird migrate
rel/bird/bin/bird start
```

### Docker

```bash
docker-compose up -d --build
docker-compose run scraper ./bin/bird migrate
docker-compose run scraper ./bin/bird foreground
```
