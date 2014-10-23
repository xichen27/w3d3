class CreateShortenedUrl < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :long_url
      t.string :short_url
      t.integer :user_id
      
    end
    
    add_index :shortened_urls, [:user_id, :short_url], unique: true
  end
end
