SambotDoesRedmine - A plugin for sambot that adds the ability to get basic ticket information out of redmine.

# Installation
Copy the SambotDoesRedmine.rb file from the repo and add it to the plugins directory of your Sambot instance.

# Configuration
First, make sure you have the Redmine REST API enabled on your redmine server.  Second, make sure you have your API key from the /my/account page in redmine.

Create a Redmine.yaml file in the Sambot config directory.  Add the following entries:

	host: <your redmine host>
	key: <your redmine user API key>

# Usage

	ticket <number>

Sam will display basic info about the ticket and a link back to the original entry in redmine.	
