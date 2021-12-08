# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe NewsItemsController, type: :controller do
    before :each do
        @rep0_params = { ocdid: '123', name: 'name0', title: 'AAA' }
        @rep0 = Representative.create(@rep0_params)
        @rep0_news_item_params = { title: 'news0', link: 'link0', representative_id: @rep0.id }
        @rep0_news_item = @rep0.news_items.create(@rep0_news_item_params)
    end

    describe 'GET #index' do
        it 'displays news items for a representative' do
            get :index, params: { representative_id: @rep0.id }
            expect(assigns(:news_items)).to include(@rep0_news_item)
            expect(response).to render_template(:index)
        end
    end
end
