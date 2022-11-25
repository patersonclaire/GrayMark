class MenusController < ApplicationController
  before_action :set_menu, only: [:show]

  def index
    @menus = Menu.all
  end

  def show
  end

  private

  def set_school
    @menu = Menu.find(params[:id])
  end
end
