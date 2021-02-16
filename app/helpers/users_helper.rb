module UsersHelper
  def has_permission?(user)
    current_user == user
  end
end
