# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :author

  def info
    return unless title

    if pages
      "#{title}: #{pages} pages by #{author.name}"
    else
      "#{title}: by #{author.name}"
    end
  end
end
