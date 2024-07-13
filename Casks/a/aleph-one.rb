cask "aleph-one" do
  version "20240712"
  sha256 "01b61b68441cb1cab8d70e41768595be3149a89fcec088ed6bc4d535d2f09fb9"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}AlephOne-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Aleph One"
  desc "Open-source continuation of Bungie's Marathon 2 game engine"
  homepage "https:alephone.lhowon.org"

  livecheck do
    url :homepage
    regex(%r{href=.*?AlephOne[._-]v?(\d+(?:\.\d+)*)[._-]Mac\.dmg}i)
  end

  depends_on macos: ">= :high_sierra"

  app "Aleph One.app"

  zap trash: [
    "~LibraryLogsAleph One Log.txt",
    "~LibraryPreferencesorg.bungie.source.AlephOne*",
    "~LibrarySaved Application Stateorg.bungie.source.AlephOne.savedState",
  ]
end