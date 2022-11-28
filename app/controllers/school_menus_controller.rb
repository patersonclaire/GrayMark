class SchoolMenusController < ApplicationController
  def index
    @school_menus = Menu.all
  end

  def show
    @school_menu = SchoolMenu.find(params[:id])
    @menus_in_week = @school_menu.menus.where(menu_date: @school_menu.date..(@school_menu.date + 5.days)).limit(5)
  end



  private

  def set_school
    @school_menu = SchoolMenu.find(params[:id])
  end

  def school_menu_params
    params.require(:date)
  end
end
