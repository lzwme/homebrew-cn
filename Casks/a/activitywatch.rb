cask "activitywatch" do
  version "0.13.0"
  sha256 "81bccef0282313f7a4199a05942a706dad518ad8af04a503adfe6f37100e7130"

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