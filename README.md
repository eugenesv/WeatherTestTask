# WeatherTestTask

Project uses http://openweathermap.org/ API for getting weather information for choosen city. The cities list was gotten from 
http://openweathermap.org/help/city_list.txt. It is a huge base of cities. Currently, there are 5 cities in project, 
only for example. These cities are stored in local data base. The DB was integrated with purpose to store weather information
some time, so user couldn't send requests to API very often. The minimum interval is 10 min.

From openweather api documentation:
How to work with API in more effective way

Do not send requests more then 1 time per 10 minutes from one device/one API key. Normally the weather is not changing 
so frequently.
Use the name of the server as api.openweathermap.org. Please never use the IP address of the server.
Better use city ID instead of city name or city coordinates.
Free account has limitation of capacity. If you do not get respond from server do not try to repeat your request immediately, 
but only after 10 min. Also please store your previous request data.
Find more features and support in our price-list or contact us via Support Center.


