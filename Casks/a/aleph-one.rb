cask "aleph-one" do
  version "20240822"
  sha256 "3374f3b639f8db1792b8215e23ab5959979b7349e3bf223463880caed9d2a2ae"

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