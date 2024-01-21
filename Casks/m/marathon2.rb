cask "marathon2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "20240119"
  sha256 "0b9e1bce0b857e42ca54ac161fa1fb7b0f533a1c00e13d48785489970d9d9fd7"

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