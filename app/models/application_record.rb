class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Slack::API
end
