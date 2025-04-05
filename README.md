# USSD menu star

This app enables static USSD menus to be created in [Avo admin](https://avohq.io/) and for these menus to be served via a callback API. The callback API is designed to work with [Africa's Talking](https://africastalking.com/ussd) [USSD callback API](https://developers.africastalking.com/docs/ussd/handle_sessions) but should be easily updatable to work with other providers.

Handling user registration, dynamic USSD menus and custom menus are outstanding features waiting to be built.

## Local development

### Install Ruby

1. Install a ruby version manager e.g. [rbenv](https://github.com/rbenv/rbenv)

2. Install the ruby version specified in `.ruby-version`, for instance

```bash
$ rbenv install 3.4.2
```

### Setup and Run Postgres

Assuming a MacOS or linux OS:
```bash
$ brew install postgresql
$ brew services start postgresql
```

### Install dependencies

```bash
$ bundle install
```

### Start using your local dev environment

You can now set up your local DBs:

```bash
$ bin/rails db:create
$ bin/rails db:create RAILS_ENV=test
$ bin/rails db:migrate
```

Run the local server with:

```bash
  bin/rails s
```

The app should now be available at http://localhost:3000

## 💯 Tests

Running tests is straightforward. Run rspec:

```bash
$ bin/rspec
```

To run system tests with a visible Chrome browser run:

```bash
  HEADLESS=false bin/rspec
```

Tests are run [automatically](.github/workflows/ci.yml) when code is pushed to GitHub.

## Production

To run the app in production a rails cache provider is required, something like [Redis](https://github.com/redis/redis-rb?tab=readme-ov-file#redis-rb--) or [Solid Cache](https://github.com/rails/solid_cache?tab=readme-ov-file#solid-cache).
