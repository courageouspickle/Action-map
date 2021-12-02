# frozen_string_literal: true

require 'rails_helper'

describe Representative do
    it 'should be valid' do
        expect(Representative).not_to raise_error
    end

    describe 'can get valid address from API' do
        before(:each) do
            @representative = Representative.new(state: 'CA')
        end

        it 'is a hash' do
            expect(@representative.address).to have_key(:state)
        end

        it 'sets state' do
            expect(@representative.state).to eq 'CA'
        end
    end
end
