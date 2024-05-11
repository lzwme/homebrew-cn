cask "aleph-one" do
  version "20240510"
  sha256 "ff60ae0fe402c63bfede1955c35dc780a5ab285e643b17c3e4ce83774fc5e4ad"

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