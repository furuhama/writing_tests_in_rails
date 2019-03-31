# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Book, type: :model do
  describe 'FactoryBot' do
    let(:book) { create(:book) }

    it { expect(book.title).to eq 'Hitsuji Wo Meguru Bouken' }
  end

  describe 'DatabaseRewinder' do
    it { expect(Book.count).to eq 0 }
  end
end
