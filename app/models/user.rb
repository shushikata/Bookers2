class User < ApplicationRecord
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy 
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  attachment :profile_image

  validates :name, presence: true, length: { minimum:2, maximum:20 }
  validates :introduction, length: { maximum:50 }



  # mailer関連 ========================================
  after_create :send_welcome_mail
 
  def send_welcome_mail
    UserMailer.user_welcome_mail(self).deliver
  end
  # ===================================================

 

  # DM関連 ===========================================================================
    has_many :messages
    has_many :sent_messages, through: :messages, source: :receive_user
    has_many :reverses_of_message, class_name: 'Message', foreign_key: 'receive_user_id'
    has_many :received_messages, through: :reverses_of_message, source: :user

    # メッセージを送るためのメソッド
    def sent_messages(other_user, content)
      unless self == other_user
        self.messages.find_or_create_by(receive_user_id: other_user.id, content: content)
      end
    end
  # ==================================================================================
  
  
  # ====================自分がフォローしているユーザーとの関連 ===================================
  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowing_id(フォローする側)
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower
  # ========================================================================================

  # ====================自分がフォローされるユーザーとの関連 ===================================
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following
  # =======================================================================================

  def followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(following_id: user.id).present?
  end

  def self.search(search,word)
    if search == "forward_match"
        @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
        @user = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
        @user = User.where("#{word}")
    elsif search == "partial_match"
        @user = User.where("name LIKE?","%#{word}%")
    else
        @user = User.all
    end
  end

  # 住所自動入力関連 ===================================================================
  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  # ==================================================================================


  # API関連 =================================================================
  def address
    "%s %s"%([self.prefecture_code, self.address_city, self.address_street])
  end
  
  geocoded_by :address
  after_validation :geocode

  # ========================================================================

end