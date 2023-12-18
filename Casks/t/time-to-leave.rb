cask "time-to-leave" do
  version "3.0.0"
  sha256 "25fef73ac373e37ba8c0363e25e7e0996afb048466698777e9f0a0e5bb8876a0"

  url "https:github.comthamaratime-to-leavereleasesdownload#{version}time-to-leave-#{version}.dmg"
  name "Time To Leave"
  desc "Log work hours and get notified when it's time to leave the office"
  homepage "https:github.comthamaratime-to-leave"

  # A tag using the stable version format is sometimes marked as "Pre-release"
  # on the GitHub releases page, so we have to use the `GithubLatest` strategy.
  livecheck do
    url :url
    regex(^\D*?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  app "Time To Leave.app"

  zap trash: [
    "~LibraryPreferencescom.electron.time-to-leave.plist",
    "~LibrarySaved Application Statecom.electron.time-to-leave.savedState",
  ]
end