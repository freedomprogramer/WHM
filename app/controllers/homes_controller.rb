class HomesController < ApplicationController
  def index
  end

  def logout
    cas_logout
  end
end
