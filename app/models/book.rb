# frozen_string_literal: true

class Book < ApplicationRecord
  belogs_to :author
end
