module ElocalApiSupport
  module Actions
    module Update
      def update
        params.permit!
        if lookup_object.update_attributes(params[associated_model_name])
          render json: lookup_object
        else
          render json:  {errors: lookup_object.errors}, status: 422
        end
      end
    end
  end
end
