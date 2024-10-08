cask "time-sink" do
  version "2.2.3"
  sha256 "560ebfb30b2203e3376241954c6fe118f6de47f89e27052c06128655852f5b93"

  url "https://manytricks.com/download/_do_not_hotlink_/timesink#{version.no_dots}.dmg"
  name "Time Sink"
  desc "Tracks how you spend your time on your computer"
  homepage "https://manytricks.com/timesink/"

  livecheck do
    url "https://manytricks.com/timesink/appcast/"
    strategy :sparkle, &:short_version
  end

  auto_updates true

  app "Time Sink.app"

  zap trash: [
    "~/Library/Preferences/com.manytricks.TimeSinkClient.plist",
    "~/Library/Time Sink",
  ]
end