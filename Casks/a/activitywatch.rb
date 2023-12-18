cask "activitywatch" do
  version "0.12.2"
  sha256 "804dd3eda377d62ac2e2d0590eced2d93ff9759594299858b7cf783294c25908"

  url "https:github.comActivityWatchactivitywatchreleasesdownloadv#{version}activitywatch-v#{version}-macos-x86_64.dmg",
      verified: "github.comActivityWatchactivitywatch"
  name "ActivityWatch"
  desc "Time tracker"
  homepage "https:activitywatch.net"

  livecheck do
    url "https:activitywatch.netdownloads"
    regex(href=.*?activitywatch[._-]v?(\d+(?:\.\d+)+)-macos-x86_64\.dmgi)
  end

  app "ActivityWatch.app"

  zap trash: [
    "~LibraryApplication Supportactivitywatch",
    "~LibraryCachesactivitywatch",
    "~LibraryLogsactivitywatch",
  ]
end