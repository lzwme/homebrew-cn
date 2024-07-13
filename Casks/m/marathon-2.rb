cask "marathon-2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "20240712"
  sha256 "7869aaa6b733860e85b7f5a9f2f9e7de31c2df02984e817c46c974e3f2a183fd"

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