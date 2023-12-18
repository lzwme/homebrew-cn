cask "time-tracker" do
  version "1.3.13"
  sha256 "a6c982ee82f8babcf0f42d49950e5b3a1d613946736a7ee4a272b05916271aeb"

  url "https:github.comrburgsttime-tracker-macreleasesdownloadv#{version}-binaryTime.Tracker-#{version}-bin.zip"
  name "TimeTracker"
  desc "Time tracking app"
  homepage "https:github.comrburgsttime-tracker-mac"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)-binary$i)
  end

  app "Time Tracker.app"
end