cask "marathon-infinity" do
  version "20240513"
  sha256 "fd575d28401cb2bd787f321d3914c815ac206f3de75f511b7cc469be753c4703"

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