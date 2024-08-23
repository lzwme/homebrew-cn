cask "marathon-infinity" do
  version "20240822"
  sha256 "0123846189c088836ce5f506c47cea2b5425db2b686eef289f9edadf812301da"

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