class Avo::Actions::UserInput::MoveDown < Avo::BaseAction
  self.name = -> { "Move user input down" }
  self.no_confirmation = true
  self.visible = -> {
    view == :index && resource
  }

  def handle(query:, fields:, current_user:, resource:, **args)
    if query.count > 1
      error "Only one selected user input at a time can be moved"
      do_nothing
      return
    elsif query.count < 1
      error "No user input selected"
      do_nothing
      return
    elsif query.last.last?
      error "The user input is already at the bottom"
      do_nothing
      return
    end
    query.last.move_lower
    succeed "Successfully moved the user input down one place"
  end
end
