class User < ActiveRecord::Base

	include RankedModel
  ranks :row_order
  has_many :sorts
  #default_scope order('row_order ASC')
  #default_scope includes(:sorts).order('sorts.sort_order ASC')

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :email,           :index    => :not_analyzed
    indexes :firstname,       :index    => :not_analyzed
    indexes :lastname,       :index    => :not_analyzed

   #indexes :published_on, :type => 'date', :include_in_all => false
  end

	attr_accessor :password
	before_save :encrypt_password
	before_create :confirmation_token

	validates_confirmation_of :password
	validates_presence_of :password, :on => :create
	validates_presence_of :email
	validates_uniqueness_of :email
	validates_presence_of :firstname, :lastname

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def email_activate
		self.email_confirmed = true
		self.confirm_token = nil
		save!(:validate => false)
	end

	def self.search(params)
		# binding.pry
	  # tire.search(load: true) do
	  #   query { string params} if params.present?
	  # end
	 tire.search() do
           if (params.present? && params.match(/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/))
           	query { string "email:#{params}" }
           else
           	query { string "*#{params}*" }
           end
        end
	end

	def self.omniauth(auth)
		#binding.pry
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.firstname = auth.info.name.partition(" ").first
      user.lastname = auth.info.name.partition(" ").last
      user.image = auth.info.image
      user.token = auth.credentials.token
      user.expires_at = Time.at(auth.credentials.expires_at)
      user.email_confirmed = true
      #user.save!
      user.save(:validate => false)
    end
  end

	private

	def confirmation_token
		if self.confirm_token.blank?
			self.confirm_token = SecureRandom.urlsafe_base64.to_s
		end
	end

end
