cask "aleph-one" do
  version "20240119"
  sha256 "5652b4f38cad56bc7bee3b5221407512daa46b6e668c821246962264c17e0363"

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