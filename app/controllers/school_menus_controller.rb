class SchoolMenusController < ApplicationController
  def index
    @school_menus = Menu.all
  end

  def show
    @school_menu = SchoolMenu.find(params[:id])
    @menus_in_week = @school_menu.menus.where(menu_date: @school_menu.date..(@school_menu.date + 18.days))
    # Grabs all the Menus for the period (3 weeks), grouped by the Day
    @menus_grouped_by_day = @school_menu.menus.group_by { |menu| menu.menu_date.strftime("%A") }
    ###
    # Structure:
    # {
    #   "Monday": [Menu #1, Menu #2, Menu #3],
    #   "Tuesday": [Menu #4, Menu #5, Menu #6],
    #   "...": [..., ..., ...]
    # }
    ###
  end

  private

  def set_school
    @school_menu = SchoolMenu.find(params[:id])
  end

  def school_menu_params
    params.require(:date)
  end
end
