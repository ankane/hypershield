# Hypershield

:zap: Shield sensitive data in Postgres and MySQL

Great for business intelligence tools like [Blazer](https://github.com/ankane/blazer)

[![Build Status](https://travis-ci.org/ankane/hypershield.svg?branch=master)](https://travis-ci.org/ankane/hypershield)

## How It Works

Hypershield creates *shielded views* (in the `hypershield` schema by default) that hide sensitive tables and columns. The advantage of this approach over column-level privileges is you can use `SELECT *`.

By default, it hides columns with:

- `encrypted`
- `password`
- `token`
- `secret`

Give database users access to these views instead of the original tables.

## Database Setup

### Postgres

Create a new schema in your database

```sql
CREATE SCHEMA hypershield;
```

Grant privileges

```sql
GRANT USAGE ON SCHEMA hypershield TO myuser;

-- replace migrations with the user who manages your schema
ALTER DEFAULT PRIVILEGES FOR ROLE migrations IN SCHEMA hypershield
    GRANT SELECT ON TABLES TO myuser;

-- keep public in search path for functions
ALTER ROLE myuser SET search_path TO hypershield, public;
```

And connect as the user and make sure there’s no access the original tables

```sql
SELECT * FROM public.users LIMIT 1;
```

### MySQL

Create a new schema in your database

```sql
CREATE SCHEMA hypershield;
```

Grant privileges

```sql
GRANT SELECT, SHOW VIEW ON hypershield.* TO myuser;
FLUSH PRIVILEGES;
```

And connect as the user and make sure there’s no access the original tables

```sql
SELECT * FROM mydb.users LIMIT 1;
```

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'hypershield', group: :production
```

Refresh the schema

```sh
rake hypershield:refresh
```

And query away on your shielded views

```sql
SELECT * FROM users LIMIT 1;
```

When you run database migrations, the schema is automatically refreshed.

## Configuration

Create `config/initializers/hypershield.rb` for configuration with

```ruby
if Rails.env.production?
  # configuration goes here
end
```

Specify the schema to use and columns to show and hide

```ruby
Hypershield.schemas = {
  hypershield: {
    hide: %w(encrypted password token secret),
    show: %w(ahoy_visits.visit_token)
  }
}
```

Log Hypershield SQL statements

```ruby
Hypershield.log_sql = true
```

## TODO

- Create CLI

## History

View the [changelog](CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/hypershield/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/hypershield/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/hypershield.git
cd hypershield
bundle install
```
