module Ownerable
  OWNER_ERROR = 'No puede agregar un usuario si no le pertenece'
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :users
  end

  def add_user(owner, user)
    validate_ownership! owner
    users << user
  end

  def validate_ownership! owner
    raise OWNER_ERROR unless is_owned_by? owner
  end

  def is_known_by? user
    users.include?(user) || is_owned_by?(user)
  end

  def is_owned_by? user
    user.id == self.owner.id
  end
end
