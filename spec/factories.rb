FactoryGirl.define do
  factory :project, class: PivotalTracker::Project do
    sequence(:id)
    sequence(:name) { |i| "Project #{i}" }
  end

  factory :story, class: PivotalTracker::Story do
    sequence(:id)
    sequence(:name) { |i| "Project #{i}" }
    story_type 'feature'
    current_state 'unstarted'
  end
end
