class PoemsController < ApplicationController
  def create
    @poem = Poem.new("sample_title", "sample_body")

    render :show, :status => :created
  end

  def poem_params                                                
    params.require(:poem).permit(:user_id)        
  end                                                             
end
