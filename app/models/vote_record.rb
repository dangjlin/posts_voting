class VoteRecord < ActiveRecord::Base
  belongs_to :post , counter_cache: true
end
