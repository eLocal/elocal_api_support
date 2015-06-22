require 'elocal_api_support/actions/create'
require 'elocal_api_support/actions/destroy'
require 'elocal_api_support/actions/index'
require 'elocal_api_support/actions/show'
require 'elocal_api_support/actions/update'

module ElocalApiSupport
  module Actions
    extend ActiveSupport::Concern

    included do
      include ElocalApiSupport::Actions::Common
      include ElocalApiSupport::Actions::Create
      include ElocalApiSupport::Actions::Destroy
      include ElocalApiSupport::Actions::Index
      include ElocalApiSupport::Actions::Show
      include ElocalApiSupport::Actions::Update
    end

    module Common
      protected

      def filtered_objects_for_json
        if associated_model_serializer
          filtered_objects.map { |r| associated_model_serializer.new(r) }
        else
          filtered_objects
        end
      end

      def associated_model_serializer
        unless @associated_model_serializer_lookup_complete
          c = "#{associated_model}Serializer"
          @associated_model_serializer =
            if Object.const_defined?(c)
              Rails.logger.debug("Using #{c}")
              c.constantize
            else
              Rails.logger.debug("No serializer #{c}")
              nil
            end
          @associated_model_serializer_lookup_complete = true
        end
        @associated_model_serializer
      end

      def associated_model_name
        @model_name ||= controller_name.singularize
      end
    end
  end
end
