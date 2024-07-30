# Event planner

> [!NOTE]
> This is an example project to demonstrate my coding skills. It is not actively maintained.

## Local Development Setup

### Requirements

* Ruby 3.3.1
* PostgreSQL >16

### App setup

After installing Ruby and PostgreSQL, follow these steps:

1. Run `bundle install` to install all necessary Gems;
2. Run `bin/setup` to prepare the database;
3. Run `rake utility:import_events` to import some events from [www.goabase.net](https://www.goabase.net/api/party);
4. Execute `bin/dev` to run the app locally.

### Using OpenWeather

This app uses the [OpenWeather API](https://openweathermap.org/) to display forecasts for events within the next 7 days. To enable this functionality:

1. Sign up for an OpenWeather API key;
2. Set the `OPENWEATHER_API_KEY` environment variable.

## How it works

This app provides a list of events. Users can view all events and sign up for their preferred ones. If the event is within the next 7 days, users can also view the weather forecast provided by OpenWeather.

On the app's root page, you'll see a list of events. By default, you'll see only the events associated with a user, but you can switch to view all events.

On the event detail page, you can sign up for the event and view the weather forecast if available.

### Event management via API

Every user can create, read, update, and delete events. The API documentation is available at `/documentation`, including information on API key usage.

## Testing

Test the application with RSpec by running the command `bundle exec rspec`.

