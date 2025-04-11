class Avo::Actions::MenuItem::MoveUp < Avo::BaseAction
  self.name = -> { "Move menu item up" }
  self.no_confirmation = true
  self.visible = -> {
    view == :index && parent_resource&.is_a?(Avo::Resources::MenuItem)
  }

  def handle(query:, fields:, current_user:, resource:, **args)
    if query.count > 2
      error "Only one selected menu item at a time can be moved"
      do_nothing
      return
    elsif query.count < 2
      error "No menu item selected"
      do_nothing
      return
    elsif query.last.first?
      error "The menu item is already at the top"
      do_nothing
      return
    end
    query.last.move_higher # the first record is the parent 🤨
    succeed "Successfully moved the menu item up one place"
  end
end
