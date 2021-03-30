class Book < ApplicationRecord
  scope :costly, -> { where("price > ?", 3000)}
  scope :written_about, -> (theme) {where("name like ?", "%#{theme}%")}
  scope :find_price, -> (price) { find_by(price: price)}

  belongs_to :publisher
  has_many :authors, through: :book_authors
  has_many :book_authors

  validates :name, presence: true
  validates :name, length: { maximum: 25}
  validates :price, numericality: {grater_than_or_equal_to: 0}
  validate do |book|
    if book.mame.include?("exercise")
      book.errors[:name] << "i don`t like execise"
    end
  end
  
  before_validation :add_lovely_to_cat

  def add_lovely_to_cat
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{mached}"
    end
  end
  
  after_destroy do
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end
  
  after_destroy :if => :high_price? do
    Rails.logger.warn "Book with high price is deleted: #{self.attrivutes}"
    Rails.logger.warn "Plese check!"
  end
  
  def high_price?
    price >= 5000
  end

  enum sales_status: {
    reservation: 0, #予約受付中
    now_on_sales: 1, #販売中
    end_of_print: 2 #販売終了
  }
end
