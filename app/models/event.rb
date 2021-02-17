class Event < ApplicationRecord
  validates :start_date,
    presence: true,
    if: :is_past?
  validates :duration,
    presence: true,
    if: :multiple_of_5?
  validates :title,
    presence: true,
    length: { in: 5..140 }
  validates :description,
    presence: true,
    length: { in: 20..1000 }
  validates :price,
    presence: true,
    numericality: { less_than_or_equal_to: 1000 }    
  validates :location,
    presence: true

  belongs_to :admin, class_name: "User"
  has_many :attendances, foreign_key: 'attended_event_id', dependent: :destroy
  has_many :attendees, foreign_key: 'attended_event_id', class_name: "User", through: :attendances

  after_create :event_recap
  def event_recap
    EventMailer.new_event(self).deliver_now
  end

  def is_past?
    if !self.start_date.nil?
      errors.add(:start_date, "Cannot create an event in the past") unless self.start_date >= DateTime.now
    end
  end

  def multiple_of_5?
    if !self.duration.nil?
      errors.add(:duration, "must be a multiple of five") unless self.duration % 5 == 0 && self.duration > 0
    else
      errors.add(:duration, "must not be nil")
    end
  end

  def end_date
    return (self.start_date + self.duration*60)
  end

  def is_free?
    self.price == 0
  end
end
