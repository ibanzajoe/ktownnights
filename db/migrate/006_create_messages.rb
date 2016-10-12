Sequel.migration do
  up do
    create_table :messages do
      primary_key :id
      Fixnum :user_id
      Fixnum :send_to_id
      Date :sent_date
      Date :received_date
      String :content


    end
  end

  down do
    drop_table :messages
  end
end
