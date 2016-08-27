# Blizzard Community API Thing

## Login

To make API requests to the Battle.net WOW Community API, create an account at https://dev.battle.net and obtain an API key.

This application will look for your API key in environment with the key WOW_COMMUNITY_API_KEY.

## Running

This project uses Sidekiq for background processing.  Sidekiq must be running for anything interesting to happen.  To start Sidekiq run

```
foreman start
```

To view the sidekiq admin interface go to http://localhost:5000/sidekiq

## Features

Currently everything is done using rake tasks

use 
```
rake -T wow
```

to see what commands are supported

For example, to import all auctions and characters for the realm Earthen Ring run
```
rake wow:auction:import
```

To load all guild rosters for all known characters as well as import all guild memberships for all characters that currently
are stored without a guild run
```
rake wow:guild:import
```