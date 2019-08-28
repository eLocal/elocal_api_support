# frozen_string_literal: true

module ElocalApiSupport
  module Actions
    module Update
      DEFAULT_IGNORED_PARAMETERS = %w(id created_at updated_at).freeze

      def update
        if lookup_object.update(parameters_available_for_update)
          render json: lookup_object
        else
          Rails.logger.info { "There was an issue updating model #{lookup_object}" }
          Rails.logger.debug { "Error details #{lookup_object.errors.to_xml}" }
          render json: { errors: lookup_object.errors }, status: 422
        end
      end

      private

      def parameters_to_ignore_from_update
        DEFAULT_IGNORED_PARAMETERS
      end

      def updatable_parameter_names
        associated_model.columns.map do |col|
          next if col.name.in?(parameters_to_ignore_from_update)

          col.array ? { col.name => [] } : col.name
        end
      end

      def parameters_available_for_update
        params[associated_model_name].permit(*updatable_parameter_names)
      end
    end
  end
end
