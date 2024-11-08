require 'rails_helper'

RSpec.describe Coupon, type: :model do

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_one :invoice }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:flat_value) }
    it { should validate_presence_of(:flat_value) }
  end
end