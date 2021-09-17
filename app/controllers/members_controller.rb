class MembersController < ApplicationController
  include MembersHelper
  before_action :set_member, only: %i[ show edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.all
  end

  def invite
    current_tenant = Tenant.first
    email = params[:email]
    user_from_email= User.where(email: email).first
    if user_in_db?(email)
      if Member.where(user: user_from_email, tenant: current_tenant).present?
        redirect_to members_path, alert: "The Organization #{current_tenant} already has a member #{email}"
        return
      else
        Member.create!(user: user_from_email, tenant: current_tenant)
        redirect_to members_path, notice: "User #{email} was added to #{current_tenant} from #{current_user}"
      end
    
     return
    else
      user_to_invite = User.invite!(email: email)
      Member.create!(user: user_to_invite, tenant: current_tenant)
      redirect_to members_path, notice: "User #{email} was invited to #{current_tenant} from #{current_user}"
    end
    
  end
  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:user_id, :tenant_id)
    end
end
