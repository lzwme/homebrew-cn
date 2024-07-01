cask "activitywatch" do
  version "0.13.1"
  sha256 "dfe4a7ab1a92307ec3e1e6ee649d76907974f4a5de8fa7719f5740040ff7ca3c"

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