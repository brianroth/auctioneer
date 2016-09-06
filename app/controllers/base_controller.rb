class BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    return api_error(status: :not_found, errors: 'Not found')
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per_page(params[:per_page])
    end

    return resource
  end

  def meta_attributes(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }.delete_if { |k, v| v.nil? }
  end

  def render_with_errors(object)
    render json: { :errors => object.errors.full_messages }, status: :unprocessable_entity
  end

  def filter_params
    params.permit!.to_h
  end
end