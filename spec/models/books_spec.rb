# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Book, type: :model do
  describe '#info' do
    context 'title がある場合' do
      context 'pages が nil の場合' do
        let(:author) { Author.create!(name: 'Haruki Murakami') }
        let(:book) { Book.create!(author: author, title: 'Hitsuji Wo Meguru Bouken', pages: nil) }

        it { expect(book.info).to eq 'Hitsuji Wo Meguru Bouken: by Haruki Murakami' }
      end

      context 'pages が 150 の場合' do
        # ここを埋めてみよう
      end
    end

    context 'title が nil の場合' do
      # ここを埋めてみよう
    end
  end
end
