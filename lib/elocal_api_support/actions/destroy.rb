module ElocalApiSupport
  module Actions
    module Destroy
      def destroy
        # record not found is ok for destroy
        render json: { errors: "Cannot retrieve record: #{params[:id]}" } and return \
          if lookup_object.nil?

        if lookup_object.destroy
          render json: lookup_object
        else
          render json: { errors: "Failed to destroy #{lookup_object}" }, status: 500
        end
      rescue ActiveRecord::RecordNotFound
        # record not found is ok for destroy
        render json: { errors: "Cannot retrieve record: #{params[:id]}" }
      end
    end
  end
end
