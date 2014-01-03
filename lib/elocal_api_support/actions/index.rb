module ElocalApiSupport
  module Actions
    module Index
      def index
        render json: {
            current_page:  current_page,
            per_page:      filtered_objects.respond_to?(:per_page) ? filtered_objects.per_page : per_page,
            total_entries: filtered_objects.total_count,
            total_pages:   filtered_objects.respond_to?(:total_pages) ? filtered_objects.total_pages : 1,
            records:       filtered_objects_for_json
          }
      end
    end
  end
end

