class Post < ActiveRecord::Base
  has_many :vote_records
  attr_accessor :can_vote_tag

  def as_json(options = {})
  super options.merge(methods: [:can_vote_tag])
  end
end

