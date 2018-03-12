class ApiController < ApplicationController

  before_action :prepare_model, only: [:index, :show, :create, :update, :destroy]
  before_action :find_record, only: [:show, :update, :destroy]

  def index
    @res = @model_class
    @res = @res.offset(params[:offset].to_i) if params[:offset]
    @res = @res.limit(params[:limit].to_i) if params[:limit]
    select_list = permitted_select_values
    @res = @res.select(select_list) if select_list
    @res = @res.ransack(params[:q]).result
    
    render json: @res
  end

  def show
    render json: @res
  end

  def create
    if @res = @model_class.create(permitted_params)
      render json: @res
    else
      invalid_resource!(@res)
    end
  end

  def update
    if @res.update_attributes(permitted_params)
      render json: @res
    else
      invalid_resource!(@res)
    end
  end

  def destroy
    @res.destroy
    raise @res.errors[:base].to_s unless @res.errors[:base].empty?
    render json: { success: true }, status: 204
  end
  
  protected
    def get_model_name
      params[:model_name].capitalize || controller_name.classify
    end

    def prepare_model
      model_name = get_model_name

      raise "Model class not present" if model_name.nil? || model_name.strip == ""
      
      @model_class = model_name.constantize
      
      raise "Model class is not ActiveRecord" unless @model_class < ActiveRecord::Base
    end

    def find_record
      @res = @model_class.find(params[@model_class.primary_key.to_sym])
    end

    def permitted_select_values
      if params[:select]
        case params[:select]
        when String
          permitted_select_value params[:select]
        when Array
          params[:select].map { |field| permitted_select_value field }.compact
        end
      end
    end
    
    def permitted_select_value field
      @select_fields ||= @model_class.column_names + extra_select_values
      (@select_fields.include? field) ? field : nil
    end

    def extra_select_values
      []
    end

    def permitted_params
      params.permit![_wrapper_options.name]
      params[_wrapper_options.name].extract! @model_class.primary_key
      params[_wrapper_options.name]
    end
end
