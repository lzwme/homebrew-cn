cask "marathon-infinity" do
  version "20231125"
  sha256 "19efb62b3759b6f572ad83b1d041e6044dfbdbdfd25a2e5dcc6e2cdc48e35038"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}MarathonInfinity-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Marathon Infinity"
  desc "First-person shooter, third in a trilogy"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?MarathonInfinity[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  app "Marathon Infinity.app"

  zap trash: [
    "~LibraryApplication SupportMarathon Infinity",
    "~LibraryLogsMarathon Infinity Log.txt",
    "~LibraryPreferencesMarathon Infinity",
    "~LibrarySaved Application Stateorg.bungie.source.MarathonInfinity.savedState",
  ]
end