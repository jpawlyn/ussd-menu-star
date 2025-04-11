class Avo::Actions::UserInput::MoveUp < Avo::BaseAction
  self.name = -> { "Move user input up" }
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
    elsif query.last.first?
      error "The user input is already at the top"
      do_nothing
      return
    end
    query.last.move_higher
    succeed "Successfully moved the user input up one place"
  end
end
