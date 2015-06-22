module ElocalApiSupport
  module Actions
    module Index
      def index
        render json: {
          current_page:  current_page,
          per_page:      paginated_request? ? per_page : filtered_objects.total_count,
          total_entries: filtered_objects.total_count,
          total_pages:   paginated_request? ? filtered_objects.total_pages : 1,
          records:       filtered_objects_for_json
        }
      end

      private

      def paginated_request?
        params[:page].present? || params[:per_page].present?
      end
    end
  end
end
