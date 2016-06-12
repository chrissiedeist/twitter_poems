class PoemsController < ApplicationController
  rescue_from Twitter::Error::Forbidden, with: :bad_request
  rescue_from Twitter::Error::BadRequest, with: :bad_request
  rescue_from Twitter::Error::TooManyRequests, with: :too_many_requests
  rescue_from Twitter::Error::Unauthorized, with: :unauthorized

  def create
    results = TwitterService.text_from_query(params[:query])

    if results
      @poem = Poem.new(params[:query], results)
      render :show, :status => :created
    else
      redirect_to :new_poem
    end
  end

  def new
    @trending_topics = TwitterService.trending_topics
  end

  private

  def bad_request
    flash[:error] = TwitterService::BAD_REQUEST_MESSAGE
    render 'error'
  end

  def too_many_requests
    flash[:error] = TwitterService::RATE_LIMIT_ERROR_MESSAGE
    render 'error'
  end

  def unauthorized 
    flash[:error] = TwitterService::UNAUTHORIZED_MESSAGE
    redirect_to :new_poem
  end
end
