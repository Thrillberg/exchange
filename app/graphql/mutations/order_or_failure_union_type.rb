class Mutations::OrderWithMutationSuccess < Types::BaseObject
  description 'A successfully returned order type'
  field :order, Types::OrderInterface, null: false
end

class Mutations::OrderWithMutationFailure < Types::BaseObject
  description 'An error response for changes to an order'
  field :error, Types::ApplicationErrorType, null: false
end

class Mutations::OrderRequiresAction < Types::BaseObject
  description 'A response indicating order needs action to be able to be submitted'
  field :action_data, GraphQL::Types::JSON, null: false, description: 'Data related to action needed'
end

class Mutations::OrderOrFailureUnionType < Types::BaseUnion
  description 'Represents either a resolved Order or a potential failure'
  possible_types Mutations::OrderWithMutationSuccess, Mutations::OrderWithMutationFailure, Mutations::OrderRequiresAction

  def self.resolve_type(object, _context)
    if object.key?(:action_data)
      Mutations::OrderRequiresAction
    elsif object.key?(:order)
      Mutations::OrderWithMutationSuccess
    elsif object.key?(:error)
      Mutations::OrderWithMutationFailure
    else
      raise "Unexpected Return value: #{object.inspect}"
    end
  end
end
