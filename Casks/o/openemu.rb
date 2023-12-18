cask "openemu" do
  on_high_sierra :or_older do
    version "2.0.9.1"
    sha256 "c6036374104e8cefee1be12fe941418e893a7f60a1b2ddaae37e477b94873790"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave :or_newer do
    version "2.3.3"
    sha256 "a732c538287c99774ce939f840952d6713ac204e2a81baa760b1d4ef9cca1a73"
  end

  url "https:github.comOpenEmuOpenEmureleasesdownloadv#{version}OpenEmu_#{version}.zip",
      verified: "github.comOpenEmuOpenEmu"
  name "OpenEmu"
  desc "Retro video game emulation"
  homepage "https:openemu.org"

  auto_updates true
  conflicts_with cask: "openemu-experimental"

  app "OpenEmu.app"

  zap trash: [
    "~LibraryApplication SupportOpenEmu",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.openemu.openemu.sfl*",
    "~LibraryApplication Supportorg.openemu.OEXPCCAgent.Agents",
    "~LibraryCachesOpenEmu",
    "~LibraryCachesorg.openemu.OpenEmu",
    "~LibraryCookiesorg.openemu.OpenEmu.binarycookies",
    "~LibraryHTTPStoragesorg.openemu.OpenEmu",
    "~LibraryHTTPStoragesorg.openemu.OpenEmu.binarycookies",
    "~LibraryPreferencesorg.openemu.Atari800.plist",
    "~LibraryPreferencesorg.openemu.Bliss.plist",
    "~LibraryPreferencesorg.openemu.BSNES.plist",
    "~LibraryPreferencesorg.openemu.CrabEmu.plist",
    "~LibraryPreferencesorg.openemu.desmume.plist",
    "~LibraryPreferencesorg.openemu.dolphin.plist",
    "~LibraryPreferencesorg.openemu.FCEU.plist",
    "~LibraryPreferencesorg.openemu.Gambatte.plist",
    "~LibraryPreferencesorg.openemu.GenesisPlus.plist",
    "~LibraryPreferencesorg.openemu.Higan.plist",
    "~LibraryPreferencesorg.openemu.Mednafen.plist",
    "~LibraryPreferencesorg.openemu.mGBA.plist",
    "~LibraryPreferencesorg.openemu.Mupen64Plus.plist",
    "~LibraryPreferencesorg.openemu.NeoPop.plist",
    "~LibraryPreferencesorg.openemu.Nestopia.plist",
    "~LibraryPreferencesorg.openemu.O2EM.plist",
    "~LibraryPreferencesorg.openemu.OpenEmu.plist",
    "~LibraryPreferencesorg.openemu.Picodrive.plist",
    "~LibraryPreferencesorg.openemu.PPSSPP.plist",
    "~LibraryPreferencesorg.openemu.ProSystem.plist",
    "~LibraryPreferencesorg.openemu.SNES9x.plist",
    "~LibraryPreferencesorg.openemu.Stella.plist",
    "~LibraryPreferencesorg.openemu.TwoMbit.plist",
    "~LibraryPreferencesorg.openemu.VecXGL.plist",
    "~LibraryPreferencesorg.openemu.VisualBoyAdvance.plist",
    "~LibrarySaved Application Stateorg.openemu.OpenEmu.savedState",
  ]
end