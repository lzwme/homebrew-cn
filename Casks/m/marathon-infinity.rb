cask "marathon-infinity" do
  version "20250302"
  sha256 "a86f4af4d2b6c15565ce524228f23d493661285353bbc708eb491815879a3f8c"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}MarathonInfinity-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Marathon Infinity"
  desc "First-person shooter, third in a trilogy"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?MarathonInfinity[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  depends_on macos: ">= :high_sierra"

  app "Classic Marathon Infinity.app"

  zap trash: [
    "~LibraryApplication SupportMarathon Infinity",
    "~LibraryLogsMarathon Infinity Log.txt",
    "~LibraryPreferencesMarathon Infinity",
    "~LibrarySaved Application Stateorg.bungie.source.MarathonInfinity.savedState",
  ]
end