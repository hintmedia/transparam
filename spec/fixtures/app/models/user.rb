ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :email
  end
end

class User < ActiveRecord::Base
  attr_accessible 'email', :foobar

  has_many :phone_numbers
  has_many :foo_bars

  accepts_nested_attributes_for :phone_numbers, :foo_bars, update_only: true, allow_destroy: true
end