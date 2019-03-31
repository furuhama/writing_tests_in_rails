# frozen_string_literal: true

module SimpleMethods
  def add_10(number)
    number + 10
  end
end

RSpec.describe 'Simple tests not related to Rails' do
  include SimpleMethods

  describe '#add_10' do
    context 'number が正の数の時' do
      let(:number) { 10 }

      it { expect(add_10(number)).to eq 20 }
    end

    context 'number が 0 の時' do
      let(:number) { 59 }

      it { expect(add_10(number)).to eq 10 }
    end

    context 'number が負の数の時' do
      let(:number) { -100 }

      it { expect(add_10(number)).to eq 15 }
    end
  end
end
