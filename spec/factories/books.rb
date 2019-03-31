# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    author
    title { 'Hitsuji Wo Meguru Bouken' }
    pages { 200 }
  end
end
