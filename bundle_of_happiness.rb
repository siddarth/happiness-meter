class BundleOfHappiness
  attr_accessor :value, :date, :time, :note

  def initialize(value, note)
    @value = value
    @date = Time.now.strftime("%B %d %Y")
    @time = Time.now.strftime("%I:%M%p")
    @note = note
  end

  def to_s
    "%f on %s at %s. Notes: %s" % [@value, @date, @time, @note]
  end
end
