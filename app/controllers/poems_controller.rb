class PoemsController < ApplicationController
  def create
    service = TwitterService.new
    results = service.text_from_query(params[:query])

    @poem = Poem.new("sample_title", results)

    render :show, :status => :created
  end
end
