require "sequel"

db_config = ENV.fetch("DATABASE_URL")
DB = Sequel.connect(db_config)
DB.test_connection

Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :association_dependencies
