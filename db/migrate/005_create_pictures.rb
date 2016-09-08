Sequel.migration do
  up do
    create_table :pictures do
      primary_key :id
      Fixnum :user_id
      String :image_url
      Boolean :main_pic


    end
  end

  down do
    drop_table :pictures
  end
end
