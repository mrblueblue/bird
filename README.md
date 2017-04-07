# Bird

Craiglist apartment scraper and slackbot written in Elixir

## Deploying

```bash
docker-compose up -d --build
docker-compose run scraper ./bin/bird migrate
docker-compose run scraper ./bin/bird foreground
```
