cask "time-tracker" do
  version "1.3.13"
  sha256 "a6c982ee82f8babcf0f42d49950e5b3a1d613946736a7ee4a272b05916271aeb"

  url "https:github.comrburgsttime-tracker-macreleasesdownloadv#{version}-binaryTime.Tracker-#{version}-bin.zip"
  name "TimeTracker"
  desc "Time tracking app"
  homepage "https:github.comrburgsttime-tracker-mac"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-14", because: :unmaintained

  app "Time Tracker.app"

  caveats do
    requires_rosetta
  end
end