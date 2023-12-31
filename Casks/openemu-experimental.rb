cask "openemu-experimental" do
  on_high_sierra :or_older do
    version "2.0.9.1"
    sha256 "62c44e823fef65c583cbf5e6f84faa03618d713f45610f73bc23fb34cbf64762"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave :or_newer do
    version "2.4.1"
    sha256 "57b6f2b6005119efecb566e8cf611e12f1d0171dcd1f96797a0e9b4c33d3cdb4"
  end

  url "https:github.comOpenEmuOpenEmureleasesdownloadv#{version}OpenEmu_#{version}-experimental.zip",
      verified: "github.comOpenEmuOpenEmu"
  name "OpenEmu"
  desc "Retro video game emulation"
  homepage "https:openemu.org"

  auto_updates true
  conflicts_with cask: "openemu"
  depends_on macos: ">= :mojave"

  app "OpenEmu.app"

  zap trash: [
    "~LibraryApplication SupportOpenEmu",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.openemu.openemu.sfl*",
    "~LibraryApplication Supportorg.openemu.OEXPCCAgent.Agents",
    "~LibraryCachesOpenEmu",
    "~LibraryCachesorg.openemu.OpenEmu",
    "~LibraryCookiesorg.openemu.OpenEmu.binarycookies",
    "~LibraryHTTPStoragesorg.openemu.OpenEmu.binarycookies",
    "~LibraryPreferencesorg.openemu.*.plist",
    "~LibrarySaved Application Stateorg.openemu.OpenEmu.savedState",
  ]
end