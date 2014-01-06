module ElocalApiSupport
  module Actions
    module Create
      def create
        params.permit!
        obj = associated_model.new(params[@model_name.to_sym])

        if obj.save
          render json: obj
        else
          render json: {errors: obj.errors}, status: 422
        end
      end
    end
  end
end