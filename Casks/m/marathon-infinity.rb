cask "marathon-infinity" do
  version "20240712"
  sha256 "b40eb95c35a2ebb768085775e66131b8fd2a33b98773b0b14974a24097f08012"

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