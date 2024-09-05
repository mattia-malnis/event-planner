# Event planner

> [!NOTE]
> This is an example project to demonstrate my coding skills. It is not actively maintained.

## Local Development Setup

### Requirements

* Ruby 3.3.4
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

On the app's root page, you'll see a list of upcoming events that can be filtered. Is possible to see also a page with a list of events subscribed by the user.

On the event detail page, you can sign up for the event and view the weather forecast if available.

This app offers a comprehensive list of events, where users can browse and sign up for the ones they are interested in. For events happening within the next 7 days, users can also view the weather forecast, powered by the OpenWeather API.

### Key Features:

* Event listings: The app's homepage displays a list of upcoming events. Users can filter the events based on their preferences.
* User-specific events: There is a dedicated page where users can view events they have signed up for.
* Event details: On each event's detail page, users can register for the event and, if applicable, view the weather forecast for the event date.

### Event management via API

Every user can create, read, update, and delete events. The API documentation is available at `/documentation`, including information on API key usage.

## Testing

Test the application with RSpec by running the command `bundle exec rspec`.

## Screenshots 

<img width="1470" alt="immagine" src="https://github.com/user-attachments/assets/880dee4e-ab64-4bc8-82e4-f2583ece0a6e">

![immagine](https://github.com/user-attachments/assets/2d7c325c-517a-4f81-8c89-fefbe1cada8f)
