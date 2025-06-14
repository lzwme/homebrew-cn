cask "charlessoft-timetracker" do
  version "0.6.4"
  sha256 :no_check

  url "https://charlessoft.com/TimeTracker.zip"
  name "TimeTracker"
  homepage "https://charlessoft.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "TimeTracker.app"
end