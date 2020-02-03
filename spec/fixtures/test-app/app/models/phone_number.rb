ActiveRecord::Schema.define do
  create_table :phone_number, force: true do |t|
    t.references :user
    t.string :number
  end
end

class PhoneNumber < ActiveRecord::Base
  attr_accessible :number

  belongs_to :users
end