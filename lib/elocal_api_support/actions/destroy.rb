module ElocalApiSupport
  module Actions
    module Destroy
      def destroy
        if lookup_object.destroy
          render json: lookup_object
        else
          render json: { errors: "Failed to destroy #{lookup_object}" }, status: 500
        end
      rescue ActiveRecord::RecordNotFound
        render json: {} # record not found is ok for destroy
      end
    end
  end
end
