class CreateAuthenticatorUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :authenticator_users do |t|
      t.timestamps
    end
  end
end
