class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :check_permission, only: [:index, :destroy]
  before_action :already_subscribed, only: [:new, :create]
  before_action :free_subscription, only: [:new, :create]
  # GET /attendances or /attendances.json
  def index
    @event = Event.find(params[:event_id])
    @attendances = @event.attendances    
  end

  # GET /attendances/new
  def new
    @user = current_user
    @event = Event.find(params[:event_id])
    @stripe_amount = (@event.price*100.to_i)
  end

  def create
    @user = current_user
    @event = Event.find(params[:event_id])
    @stripe_amount = (@event.price*100.to_i)
    begin 
      customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
      })  
      charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @stripe_amount,
      description: "Achat d'un produit",
      currency: 'eur',
      })
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_event_attendance_path
    end
    if !customer.nil?
      @event.attendances << Attendance.create(attendee_id:current_user.id, attended_event_id: @event.id, stripe_customer_id:customer.id)
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.require(:attendance).permit(:user_id, :event_id)
    end

    def check_permission
      @event = Event.find(params[:event_id])
      if !has_permission?(@event.admin)
        redirect_to root_path
        flash[:danger] = "Tu ne peux pas voir le détail d'un événement dont tu n'es pas administrateur."
      end
    end

    def already_subscribed
      @event = Event.find(params[:event_id])
      if !current_user.nil? && !Attendance.where(attendee_id: current_user.id, attended_event_id:@event.id).empty?
        redirect_to @event
        flash[:warning] = "Tu es déjà inscrit !"
      elsif current_user == @event.admin
        redirect_to @event
        flash[:warning] = "Tu ne peux pas t'inscrire à ton propre événement !"
      end
    end

    def free_subscription
      @event = Event.find(params[:event_id])
      if @event.is_free?
        @event.attendances << Attendance.create(attendee_id:current_user.id, attended_event_id: @event.id)
        redirect_to @event
        flash[:success] = "Tu es inscrit à cet événement gratuit !"
      end
    end
end
