# awscredentialsetup
Create or update the .aws/credentials file on the build machine. This is based on credentials.ps1. This used to be added to all MAUI projects, so it was taken out and converted to an action.

Node modules are needed to be added here since we do not run npm install within the action.
