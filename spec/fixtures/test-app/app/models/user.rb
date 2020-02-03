ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :email
  end
end

class User < ActiveRecord::Base
  attr_accessible :email, :phone_numbers_attributes

  has_many :phone_numbers

  accepts_nested_attributes_for :phone_numbers, update_only: true, allow_destroy: true
end