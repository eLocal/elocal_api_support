module ElocalApiSupport::ModelFromParams
  #
  # Including classes need to define methods
  #  - params
  #  - associated_model_name
  #

  protected

  def lookup_object
    @lookup_object ||= with_includes(associated_model.where(id: params[:id])).first
  end

  def filtered_objects
    @filtered_objects ||= with_pagination(with_sorting(with_filters(with_includes(associated_model))))
  end

  def with_pagination(rel)
    if paginated_request?
      rel.page(current_page).per(per_page)
    else
      rel.page(current_page).limit(false)
    end
  end

  def with_filters(rel)
    allowed_filter_columns.each do |param_name|
      if params[param_name].present?
        if respond_to?(:"with_#{associated_model.to_s.downcase}_by_#{param_name}", true)
          rel = send(:"with_#{associated_model.to_s.downcase}_by_#{param_name}", params[param_name])
        elsif associated_model.respond_to?(:"with_#{param_name}", true)
          rel = rel.send(:"with_#{param_name}", params[param_name])
        else
          rel = rel.where(param_name.to_sym => params[param_name])
        end
      end
    end

    rel
  end

  def with_sorting(rel)
    if filter_sort_col.present?
      if respond_to?(:"order_#{associated_model.to_s.downcase}_by_#{filter_sort_col}", true)
        rel = send(:"order_#{associated_model.to_s.downcase}_by_#{filter_sort_col}", rel)
      elsif associated_model.respond_to?(:"order_by_#{filter_sort_col}", true)
        rel = rel.send(:"order_by_#{filter_sort_col}", params[filter_sort_col], filter_sort_direction)
      else
        rel = rel.order("#{associated_model.table_name}.#{filter_sort_col} #{filter_sort_direction}")
      end
    end
    rel
  end

  def with_includes(rel)
    rel
  end

  def default_per_page
    500
  end

  def per_page
    @per_page ||= (params[:per_page] || default_per_page).to_i
  end

  def current_page
    @current_page ||= (params[:page] || 1).to_i
  end

  def allowed_sort_columns
    associated_model_columns
  end

  def allowed_filter_columns
    associated_model_columns
  end

  def associated_model
    @associated_model ||= associated_model_name.camelize.constantize
  end

  def associated_model_columns
    @associated_model_columns ||= associated_model.columns.map(&:name)
  end

  def filter_sort_col
    params[:sort][:key] \
      if params[:sort] && params[:sort][:key] && allowed_sort_columns.include?(params[:sort][:key])
  end

  def filter_sort_direction
    if params[:sort] && params[:sort][:direction] && %w(asc desc).include?(params[:sort][:direction])
      params[:sort][:direction]
    else
      ''
    end
  end
end
