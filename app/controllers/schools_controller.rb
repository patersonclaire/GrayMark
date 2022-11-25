class SchoolsController < ApplicationController
  before_action :set_school, only: [:show]

  def index
    @schools = School.all
  end

  def show
  end

  private

  def set_school
    @school = School.find(params[:id])
  end
end
