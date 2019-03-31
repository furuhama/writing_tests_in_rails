# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Book, type: :model do
  describe '#info' do
    context 'page が nil の場合' do
      let(:author) { Author.create!(name: 'Haruki Murakami') }
      let(:book) { Book.create!(:book, author: author, title: '', page: nil) }

      it { expect(book.info).to eq '' }
    end

    context 'page が 150 の場合' do
      # ここを埋めてみよう
    end

    context 'title が nil の場合' do
      # ここを埋めてみよう
    end
  end
end
