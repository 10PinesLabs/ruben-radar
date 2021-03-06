require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'When creating an answer' do
    context 'with no axis' do
      it 'should raise an error' do
        expect { Answer.create! }.to raise_error do |error|
          expect(error).to be_a(ActiveRecord::RecordInvalid)
          expect(error.record.errors[:axis]).to be_include Answer::ERROR_MESSAGE_FOR_NO_AXIS
        end
      end
    end
    context 'with no vote' do
      it 'should raise an error' do
        expect { Answer.create! }.to raise_error do |error|
          expect(error).to be_a(ActiveRecord::RecordInvalid)
          expect(error.record.errors[:vote]).to be_include "can't be blank"
        end
      end
    end
    context 'with more than 5 points' do
      it 'should raise an error' do
        expect { Answer.create!(points: 6) }.to raise_error do |error|
          expect(error).to be_a(ActiveRecord::RecordInvalid)
          expect(error.record.errors[:points]).to be_include Answer::ERROR_MESSAGE_FOR_OUT_OF_RANGE_POINT
        end
      end
    end
  end
end
