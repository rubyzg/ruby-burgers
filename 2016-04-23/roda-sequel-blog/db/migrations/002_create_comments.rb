Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :post_id, :posts
      column :body, :text
      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
