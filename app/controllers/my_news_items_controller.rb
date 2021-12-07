# frozen_string_literal: true

class MyNewsItemsController < SessionController
    before_action :set_representative
    before_action :set_representatives_list
    before_action :set_issues_list
    before_action :set_news_item, only: %i[edit update destroy]
    before_action :set_rating, only: %i[edit update destroy]
    before_action :set_rating_params, only: %i[update]

    def new
        @news_item = NewsItem.new
    end

    def edit; end

    def create
        @news_item = NewsItem.new(news_item_params)
        if @news_item.save
            redirect_to representative_news_item_path(@representative, @news_item),
                        notice: 'News item was successfully created.'
        else
            render :new, error: 'An error occurred when creating the news item.'
        end
    end

    def update
        if @news_item.update(news_item_params)
            redirect_to representative_news_item_path(@representative, @news_item),
                        notice: 'News item was successfully updated.'
        else
            render :edit, error: 'An error occurred when updating the news item.'
        end
    end

    def destroy
        @news_item.destroy
        redirect_to representative_news_items_path(@representative),
                    notice: 'News was successfully destroyed.'
    end

    private

    def set_representative
        @representative = Representative.find(
            params[:representative_id]
        )
    end

    def set_representatives_list
        @representatives_list = Representative.all.map { |r| [r.name, r.id] }
    end

    def set_issues_list
        #         @issues_list = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security
        # and Medicare', 'Abortion', 'Student Loans', 'Gun Control', 'Unemployment',
        # 'Climate Change', 'Homelessness', 'Racism', 'Tax Reform', 'Net Neutrality',
        # 'Religious Freedom', 'Border Security', 'Minimum Wage', 'Equal Pay']
        @issues_list = NewsItem.all_issues
    end

    def set_news_item
        @news_item = NewsItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_item_params
        params.require(:news_item).permit(:news, :title, :description, :link, :representative_id)
    end

    def set_rating
        @rating = @news_item.ratings.find_by user_id: @current_user.id
    end

    def set_rating_params
        rating_params[:user_id] = @current_user.id
        rating_params[:news_item_id] = @news_item.id
    end

    def rating_params
        params.require(:rating).permit(:score)
    end
end
