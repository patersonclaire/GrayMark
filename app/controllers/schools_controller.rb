class SchoolsController < ApplicationController
  before_action :set_school, only: [:show]

  def index
    @schools = School.all
  end

  def show
    # raise
    @school_menus = @school.school_menus.where("date >= ?", Date.today).order(:date)

    @first_school_menu = @school_menus.first
    @first_week_menus = @first_school_menu.menus.where("EXTRACT(dow from menu_date) = ?", Date.current.monday.wday).where(menus: { menu_date: @first_school_menu.date })

    @second_school_menu = @school_menus.second
    @second_week_menus = @second_school_menu.menus.where("EXTRACT(dow from menu_date) = ?", Date.current.monday.wday).where(menus: { menu_date: @second_school_menu.date })

    @third_school_menu = @school_menus.third
    @third_week_menus = @third_school_menu.menus.where("EXTRACT(dow from menu_date) = ?", Date.current.monday.wday).where(menus: { menu_date: @third_school_menu.date })
  end

  private

  def set_school
    @school = School.find(params[:id])
  end
end
