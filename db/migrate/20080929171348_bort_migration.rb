class BortMigration < ActiveRecord::Migration
  def self.up
    # Create Sessions Table
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    
    # Create Users Table
    create_table :users do |t|
      t.string :name, :limit => 100, :default => '', :null => true
      t.string :email, :limit => 100
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.datetime :activated_at
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :users, :email, :unique => true

    # Create Passwords Table
    create_table :passwords do |t|
      t.integer :user_id
      t.string :reset_code
      t.datetime :expiration_date
      t.timestamps
    end
  end

  def self.down
    # Drop all Bort tables
    drop_table :sessions
    drop_table :users
    drop_table :passwords
  end
end
