class PivotalTracker::Story
  def unstarted?
    current_state == 'unstarted'
  end
end
