Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      column :title, :varchar
      column :body, :text
      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
