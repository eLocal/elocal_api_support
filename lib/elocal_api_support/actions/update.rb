module ElocalApiSupport
  module Actions
    module Update
      def update
        params.permit!
        if lookup_object.update_attributes(parameters_available_for_update)
          render json: lookup_object
        else
          render json:  { errors: lookup_object.errors }, status: 422
        end
      end

      private

      def parameters_available_for_update
        params[associated_model_name].reject { |(k, _v)| k.in?(parameters_to_ignore_from_update) }
      end

      def parameters_to_ignore_from_update
        %w(id created_at updated_at).freeze
      end
    end
  end
end
