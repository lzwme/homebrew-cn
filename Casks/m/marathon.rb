cask "marathon" do
  version "20250302"
  sha256 "ec9436141c6d1a9eed6e739868acf4dae886aefe7d2f9d3f795efd1f4224f741"

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