class PollsController < ApplicationController
  before_filter :get_poll, except: [:index, :new, :create]
  respond_to :js

  def add
  end

  def create
    @poll = Poll.new params[:poll]
    @poll.user = cuser
    raise AccessError unless @poll.can_create? cuser

    if @poll.save
      flash[:notice] = t(:polls_create)
      redirect_to @poll
    else
      render :new
    end
  end

  def update
    raise AccessError unless @poll.can_update? cuser

    if @poll.update_attributes params[:poll]
      flash[:notice] = t(:polls_update)
      redirect_to @poll
    else
      render :edit
    end
  end

  def destroy
    raise AccessError unless @poll.can_destroy? cuser
    @poll.destroy
    redirect_to polls_url
  end

  private

  def get_poll
    @poll = Poll.find params[:id]
  end
end
