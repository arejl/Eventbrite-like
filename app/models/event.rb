class Event < ApplicationRecord
  validates :start_date,
    presence: true,
    if: :is_past?
  validates :duration,
    presence: true,
    numericality: { greater_than: 0 },
    if: :multiple_of_5?
  validates :title,
    presence: true,
    length: { in: 5..140 }
  validates :description,
    presence: true,
    length: { in: 20..1000 }
  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }    
  validates :location,
    presence: true
  belongs_to :admin, class_name: "User"
  has_many :attendances
  has_many :attendees, class_name: "User", through: :attendances

  after_create :event_recap
  def event_recap
    EventMailer.new_event(self).deliver_now
  end

  def is_past?
    errors.add(:start_date, "Cannot create an event in the past") unless self.start_date > DateTime.now
  end

  def multiple_of_5?
    errors.add(:duration, "Duration must be a multiple of five") unless self.duration % 5 == 0
  end
end
