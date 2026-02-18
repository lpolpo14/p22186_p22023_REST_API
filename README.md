# README

Developed by P22186 (Michael Favvas) and P22023 (Dimitrios Vlachopoulos)

Used **ruby 3.4.7** and **Rails 8.1.2**.

## How to run

Follow these steps:

```console
# Install all the Gems
bundle install 

# Create the Database 
rails db:create

# Run the Migrations
rails db:migrate

# Prepere the Test DB
rails db:test:prepare

# Start the server
rails server
```

**Swagger UI** is available at http://localhost:3000/api-docs/index.html . It was generated using **RSwag**, with the relevant files being located in spec/integration. When testing exclude that directory (Or remove it entirely).
