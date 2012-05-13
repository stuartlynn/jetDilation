class CreateTripits < ActiveRecord::Migration
  def change
    create_table :tripits do |t|

      t.timestamps
    end
  end
end
