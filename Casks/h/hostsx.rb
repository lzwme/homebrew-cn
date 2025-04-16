cask "hostsx" do
  version "2.9.0"
  sha256 "5a8fc616b6e28465ba9edfbbd647285f33add8b1790c517ece55df3aec5b73a0"

  url "https:github.comZzzMHostsXreleasesdownload#{version}HostsX.dmg"
  name "HostsX"
  desc "Local hosts update tool"
  homepage "https:github.comZzzMHostsX"

  livecheck do
    url "https:zzzm.github.ioHostsXappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "HostsX.app"

  zap trash: [
    "~LibraryHTTPStoragescom.alpha.hostsx",
    "~LibraryPreferencescom.alpha.hostsx.plist",
  ]
end