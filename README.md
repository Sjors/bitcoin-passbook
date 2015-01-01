## Setup

Install Postgres and run:

    bundle install
    rake db:create
    rake db:migrate
  
Create an account on Coinbase and put the following in a file called `.env`:
  
    COINBASE_API_KEY=...
    COINBASE_SHARED_SECRET=...
    PRICE=0.0001
  
Now run the server: `rails server`
  
[ ![Codeship Status for Sjors/bitcoin-passbook](https://www.codeship.io/projects/0825cfa0-a110-0130-3896-7214dcb07260/status?branch=production)](https://www.codeship.io/projects/3527)

