cask "marathon-2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "20240822"
  sha256 "c863a9e92acd8ecd0dc2ad3e5391a87925d78b695c348f55fa1c7e4c75b02303"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}Marathon2-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Marathon 2"
  desc "First-person shooter, second in a trilogy"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?Marathon2[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  depends_on macos: ">= :high_sierra"

  app "Classic Marathon 2.app"

  zap trash: [
    "~LibraryApplication SupportMarathon 2",
    "~LibraryLogsMarathon 2 Log.txt",
    "~LibraryPreferencesMarathon 2",
    "~LibrarySaved Application Stateorg.bungie.source.Marathon2.savedState",
  ]
end