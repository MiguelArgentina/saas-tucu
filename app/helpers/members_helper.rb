module MembersHelper
  
  def user_in_db?(email)
    User.where(email: email).first.present?
  end
  
end
