cask "marathon" do
  version "20231125"
  sha256 "5d4bc15823dd917010c116d9ff2d029ffbab77dc891fecf27943a003a3c6a0d5"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}Marathon-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Marathon"
  desc "First-person shooter, first in a trilogy"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?Marathon[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  app "Marathon.app"

  zap trash: [
    "~LibraryApplication SupportMarathon",
    "~LibraryLogsMarathon Log.txt",
    "~LibraryPreferencesMarathon",
    "~LibrarySaved Application Stateorg.bungie.source.Marathon.savedState",
  ]
end