class PoemsController < ApplicationController
  def create
    results = TwitterService.text_from_query(params[:query])

    @poem = Poem.new(params[:query], results)

    render :show, :status => :created
  end

  def new
    @trending_topics = TwitterService.trending_topics || []
  end
end
