require 'rails_helper'

RSpec.describe Item do

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoiceItems}
  end
end