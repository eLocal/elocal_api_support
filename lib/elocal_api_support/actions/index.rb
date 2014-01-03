module ElocalApiSupport
  module Actions
    module Index
      def index
        render json: {
            current_page:  current_page,
            per_page:      (params[:page].present? || params[:per_page].present?) ? per_page : filtered_objects.total_count,
            total_entries: filtered_objects.total_count,
            total_pages:   (params[:page].present? || params[:per_page].present?) ? filtered_objects.total_pages : 1,
            records:       filtered_objects_for_json
          }
      end
    end
  end
end

