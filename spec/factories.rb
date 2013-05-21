FactoryGirl.define do
  factory :project, class: PtGit::Project do
    sequence(:id)
    sequence(:name) { |i| "Project #{i}" }
  end

  factory :story, class: PivotalTracker::Story do
    sequence(:id)
    sequence(:name) { |i| "Project #{i}" }
    story_type 'feature'
    current_state 'unstarted'
    owned_by 'Tien Le'
  end

  factory :membership, class: PivotalTracker::Membership do
    name 'Tien Le'
    initials 'TL'
    sequence(:email) {|n| "email#{n}@thehamon.com" }
  end
end
