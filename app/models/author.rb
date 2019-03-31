# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :books

  validates :name, presence: true

  def greet
    if age
      "Hi, my name is #{} and I am #{age} years old."
    else
      "Hi, my name is #{}."
    end
  end
end
