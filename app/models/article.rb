class Article < ActiveRecord::Base
  # Para el fk
  include AASM
  belongs_to :user
  #
  validates :title,presence: true , uniqueness:true
  validates :body,presence: true, length: {minimum: 20}
  before_create :set_visits_count
  has_many :comments
  after_create :save_categories
  # after_create :send_mail
  # has_attached_file :cover,styles: { thumb: '120x120', large: '300x400' }
  has_attached_file :cover
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/

  has_many :has_categories
  has_many :categories, through: :has_categories

  scope :publicados,->{where(state:"published")}

  scope :ultimos,->{order("created_at DESC")}

  aasm column: "state" do
    state :in_draft , initial: true
    state :published

    event :publish do
      transitions from: :in_draft, to: :published
    end

    event :unpublish do
      transitions from: :published, to: :in_draft
    end
end

def categories=(value)
  @categories = value
end

  def update_visits_count
    self.update(visits_count: self.visits_count+1);
  end
  private

  def send_mail
    ArticleMailer.new_article(self).deliver_later
  end
  def save_categories

    @categories.each do |category_id|
        HasCategory.create(category_id: category_id,article_id: self.id)

    end
  end
  def set_visits_count
    self.visits_count = 0
  end
end
