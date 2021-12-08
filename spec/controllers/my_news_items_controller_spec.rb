# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe MyNewsItemsController, type: :controller do
    before :each do
        @rep0_params = { ocdid: '123', name: 'name0', title: 'AAA' }
        @rep0 = Representative.create(@rep0_params)
        @rep0_news_item_params = { title: 'news0', link: 'link0', representative_id: @rep0.id, issue: 'Terrorism' }
        @rep0_news_item = @rep0.news_items.create(@rep0_news_item_params)
    end

    describe 'POST #create' do
        it 'creates a new News Item for a representative' do
            post :create, params: { title: 'news10', link: 'link10', representative_id: @rep0.id, issue: 'Terrorism' }
            expect(response).to redirect_to(:login)
            expect(NewsItem.exists?(title: 'news10')).to be false
        end
    end
end
