# A work around while waiting for this patch to be accepted
# https://github.com/jsmestad/pivotal-tracker/issues/67
#
module PivotalTracker
  class Iteration
    has_many :stories, Story, :xpath => './/stories'
  end
end
