module ElocalApiSupport
  module Actions
    module Show
      def show
        render json: lookup_object
      end
    end
  end
end