class Avo::Actions::MenuItem::MoveDown < Avo::BaseAction
  self.name = -> { "Move menu item down" }
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
    elsif query.last.last?
      error "The menu item is already at the bottom"
      do_nothing
      return
    end
    query.last.move_lower # the first record is the parent 🤨
    succeed "Successfully moved the menu item down one place"
  end
end
