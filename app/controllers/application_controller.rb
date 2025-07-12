class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :set_default_meta

  private

  def set_default_meta
    set_meta_tags(default_meta_tags)
  end
end
