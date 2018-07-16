class OperationsController < ApplicationController
  before_action :set_operation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  # GET /operations
  # GET /operations.json
  def index
    @operations = current_user.operations.all
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
  end

  # GET /operations/new
  def new
    @operation = Operation.new
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  # POST /operations.json
  def create
    @operation = current_user.operations.new(operation_params)
    respond_to do |format|
      if @operation.save
          @total = Total.find_by_user_id(current_user.id)
          if @operation.operation_type == "Deposit"
            if @total.present?
              value = @operation.value.to_i + @total.amount.to_i
              @total.update_attributes(:amount => value, user_id: current_user.id)
            else
              @amount = Total.create(:amount => @operation.value, user_id: current_user.id)
            end
          else
            if @total.present?
              value =  @total.amount.to_i - @operation.value.to_i
              @total.update_attributes(:amount => value, user_id: current_user.id)
            else
              @amount = Total.create(:amount => @operation.value, user_id: current_user.id)
            end
          end
        format.html { redirect_to @operation, notice: 'Operation was successfully created.' }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to @operation, notice: 'Operation was successfully updated.' }
        format.json { render :show, status: :ok, location: @operation }
      else
        format.html { render :edit }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation.destroy
    respond_to do |format|
      format.html { redirect_to operations_url, notice: 'Operation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = Operation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_params
      params.require(:operation).permit(:operation_type, :value, :user_id)
    end
end
