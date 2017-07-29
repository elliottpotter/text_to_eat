class CreateAllflicksCookies < ActiveRecord::Migration[5.0]
  def change
    create_table :allflicks_cookies do |t|
      t.string :phpsessid
      t.string :identifier

      t.timestamps
    end
  end
end
