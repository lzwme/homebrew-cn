cask "activitywatch" do
  version "0.13.2"
  sha256 "22f3bce0e169457902b2c8d2967701cde887171f737d281dd414a210bd3090ed"

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

  caveats do
    requires_rosetta
  end
end