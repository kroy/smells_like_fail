# Smells Like Fail
### A Heroes of Newerth stats webapp
##### by [kroy](http://github.com/kroy)

*Smells Like Fail* is a webapp which pulls and aggregates stats for users and the **Heroes of Newerth** games they have participated in.
The app is built in Rails and uses bootstrap, jquery, and [highcharts](http://www.highcharts.com/) for the frontend.
For now, the app is hosted on Heroku at: [smellslikefail.herokuapp.com](smells.likefail.heroapp.com). 
However this will change once I spin up an AWS micro-instance.

The goal of this app is to help **Heroes of Newerth** players of all skill levels analyze individual games, gain insights into their play-style, see how they match up against the community,
and, ultimately, improve their **HoN** skills.

## Features

The key features planned for the beta release of the *Smells Like Fail* webapp are:

	1. Full match history for any user who has signed up
	2. Intuitive presentation of stats, broken down by player and by match
	3. Graphs and displays to assist in the analysis of games and overall playing trends for individual users and the community as a whole
	4. Deep inspection of game logs in order to provide game information beyond simple statistics

Eventually, I would also like to add the following features:

	1. Full parses of **Heroes of Newerth** replay files
	2. The ability to comment, share knowledge, and post articles
	3. Support for other MOBA games (**Dota 2** and **League of Legends**)

## Details

This app is built in Rails 3.2 with bootstrap, jquery, and highcharts.  Stat information is pulled from the [**Heroes of Newerth** stats API](api.heroesofnewerth.com). 
The **HoN** stats API requires requests to originate from a static IP, which is associated with an API key.  As such, Heroku is not an appropriate hosting platform. 

### Models

Currently, there are three main models in the webapp: users, matches, and match-stats.

Users
: Represents all stat information associated with a particular account such as kill-to-death ratio, average gold per minute, etc

Matches
: Represents information about a particular match, such as duration and winner

Match-Stats
: Represents all the information for a particular user in a particular game.  This model connects users to matches and is a major unit of interest for users.

Each model also handles sending requests to the **HoN** stats API where appropriate.