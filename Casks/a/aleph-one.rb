cask "aleph-one" do
  version "20231125"
  sha256 "0b6095f0335350a9b30dfcd42008b8b2bf211e0107070d905c1d70d8c81369ec"

  url "https:github.comAleph-One-Marathonalephonereleasesdownloadrelease-#{version}AlephOne-#{version}-Mac.dmg",
      verified: "github.comAleph-One-Marathonalephone"
  name "Aleph One"
  desc "Open-source continuation of Bungie’s Marathon 2 game engine"
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