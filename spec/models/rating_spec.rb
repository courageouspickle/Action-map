# frozen_string_literal: true

require 'rails_helper'

describe Rating do
    it 'should be a valid object' do
        expect { Rating }.not_to raise_error
    end

    before :each do
        @rep0_params = { ocdid: '123', name: 'name0', title: 'AAA' }
        @rep0 = Representative.create(@rep0_params)
        @rep0_news_item_params = { title: 'news0', link: 'link0', representative_id: @rep0.id }
        @rep0_news_item = @rep0.news_items.create(@rep0_news_item_params)
        @rating0 = @rep0_news_item.ratings.create(score: 1)
    end

    describe 'create a new rating instance' do
        it 'contains correct score' do
            expect(@rating0.score).to eq 1
        end

        it 'is associated with a news item' do
            expect(@rating0.news_item).to eq(@rep0_news_item)
            @rating0 = Rating.create(score: 1, news_item_id: @rep0_news_item.id)
            expect(@rating0.news_item).to eq(@rep0_news_item)
        end
    end
end
