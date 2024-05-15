cask "marathon" do
  version "20240513"
  sha256 "07ca4fda79e8d26a4c95c99e59a6079e492f4ff23277432580d6f911321f48ab"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}Marathon-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Marathon"
  desc "First-person shooter, first in a trilogy"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?Marathon[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  depends_on macos: ">= :high_sierra"

  app "Classic Marathon.app"

  zap trash: [
    "~LibraryApplication SupportMarathon",
    "~LibraryLogsMarathon Log.txt",
    "~LibraryPreferencesMarathon",
    "~LibrarySaved Application Stateorg.bungie.source.Marathon.savedState",
  ]
end