class Ability
  include CanCan::Ability

  #               👇 Will be the `current_user`
  def initialize(user)

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #

    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #

    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # Use the `alias_action` method to assign multiple action names to
    # the same action. This means that the aliased can be used in place
    # for any of the supplied actions.
    # In this case, :crud can be used in place of :create, :read, :update
    # or :delete.
    alias_action(:create, :read, :update, :delete, to: :crud)

    # The first argument to `can` is the action you are giving the user
    # permission to do.

    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource. Usually, we pass the class of a model.

    # (Optional) A block argument is used to determine whether or not a user
    # can perform said action on the resource. If the block returns `true`,
    # the user can the perform action. Otherwise, they can't.
    can(:crud, Question) do |question|
      user == question.user
    end

    can(:crud, Answer) do |answer|
      user == answer.user
    end
  end
end
