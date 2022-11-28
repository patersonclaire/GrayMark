class MenusController < ApplicationController
  before_action :set_menu, only: [:show]

  def index
    @menus = Menu.all
  end

  def show
    @weekly_school_menu = SchoolMenu.find(params[:school_menu_id])
    @menus_in_week = @weekly_school_menu
                      .menus
                      .where(menu_date: @weekly_school_menu.date..(@weekly_school_menu.date + 5.days))
                      .limit(5)
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end
end
