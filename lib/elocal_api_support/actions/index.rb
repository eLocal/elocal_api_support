module ElocalApiSupport
  module Actions
    module Index
      def index
        add_pagination_headers \
          if paginated_request? && paginate_with_headers?

        render_filtered_objects_as_json
      end

      protected

      # Her library likes to paginate with headers,
      # ActiveResource cannot handle headers.
      # So awesomely, two implementations. To use the "Her" implementation with headers
      # this method should be overridend to return true
      def paginate_with_headers?
        false
      end

      private

      def render_paginated_results_without_headers
        render json: {
          current_page:  current_page,
          per_page:      paginated_request? ? per_page : filtered_objects.total_count,
          total_entries: filtered_objects.total_count,
          total_pages:   paginated_request? ? filtered_objects.total_pages : 1,
          records:       filtered_objects_for_json
        }
      end

      def render_paginated_results_with_headers
        render json: filtered_objects_for_json
      end

      def render_filtered_objects_as_json
        if paginate_with_headers?
          render_paginated_results_with_headers
        else
          render_paginated_results_without_headers
        end
      end

      def add_pagination_headers
        logger.debug { format 'Adding pagination headers for filtered_objects collection of size %d', filtered_objects.total_count }
        response.headers['x-total'] = filtered_objects.total_count.to_s
        response.headers['x-per-page'] = per_page.to_s
        response.headers['x-page'] = current_page.to_s
      end

      def paginated_request?
        params[:page].present? || params[:per_page].present?
      end
    end
  end
end
