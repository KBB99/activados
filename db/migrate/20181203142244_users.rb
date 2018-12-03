class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :email


      t.timestamps


    end
    add_index :users, :email, unique: true
    add_column :users, :password_digest, :string
    add_column :users, :remember_digest, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
    add_column :users, :reset_digest, :string
    add_column :users, :reset_sent_at, :datetime

    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    add_column :microposts, :picture, :string

    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true

    create_table :conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :perspective

      t.timestamps
    end

    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true
      t.references :user, index: true
      t.boolean :read, :default => false
      t.timestamps
    end

    create_table :pictures do |t|
      t.integer :person
      t.integer :type
      t.integer :location

      t.timestamps
    end

    add_column :users, :picture, :string
    add_column :microposts, :name, :string
    add_column :microposts, :users, :integer
    add_column :users, :micropost_id, :integer

    create_join_table :users, :microposts do |t|
      t.index [:user_id, :micropost_id]
      t.index [:micropost_id, :user_id]
    end

    create_table :project_files do |t|
      t.string :name
      t.references :micropost, foreign_key: true

      t.timestamps
    end
    add_index :project_files, :created_at

    add_column :project_files, :url, :string
    add_column :project_files, :user_id, :string
    add_column :project_files, :content_type, :string

  end

end
