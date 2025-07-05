cask "openemu-nonmetal" do
  version "2.0.9.1"
  sha256 "c6036374104e8cefee1be12fe941418e893a7f60a1b2ddaae37e477b94873790"

  url "https://ghfast.top/https://github.com/OpenEmu/OpenEmu/releases/download/v#{version}/OpenEmu_#{version}.zip",
      verified: "github.com/OpenEmu/OpenEmu/"
  name "OpenEmu"
  desc "Retro video game emulation"
  homepage "https://openemu.org/"

  deprecate! date: "2019-10-26", because: :discontinued

  auto_updates true
  conflicts_with cask: ["openemu-experimental", "openemu"]

  app "OpenEmu.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.openemu.openemu.sfl*",
    "~/Library/Application Support/OpenEmu",
    "~/Library/Application Support/org.openemu.OEXPCCAgent.Agents",
    "~/Library/Caches/OpenEmu",
    "~/Library/Caches/org.openemu.OpenEmu",
    "~/Library/Cookies/org.openemu.OpenEmu.binarycookies",
    "~/Library/HTTPStorages/org.openemu.OpenEmu.binarycookies",
    "~/Library/Preferences/org.openemu.Atari800.plist",
    "~/Library/Preferences/org.openemu.Bliss.plist",
    "~/Library/Preferences/org.openemu.CrabEmu.plist",
    "~/Library/Preferences/org.openemu.desmume.plist",
    "~/Library/Preferences/org.openemu.FCEU.plist",
    "~/Library/Preferences/org.openemu.Gambatte.plist",
    "~/Library/Preferences/org.openemu.GenesisPlus.plist",
    "~/Library/Preferences/org.openemu.Higan.plist",
    "~/Library/Preferences/org.openemu.Mednafen.plist",
    "~/Library/Preferences/org.openemu.mGBA.plist",
    "~/Library/Preferences/org.openemu.Mupen64Plus.plist",
    "~/Library/Preferences/org.openemu.NeoPop.plist",
    "~/Library/Preferences/org.openemu.Nestopia.plist",
    "~/Library/Preferences/org.openemu.O2EM.plist",
    "~/Library/Preferences/org.openemu.OpenEmu.plist",
    "~/Library/Preferences/org.openemu.Picodrive.plist",
    "~/Library/Preferences/org.openemu.PPSSPP.plist",
    "~/Library/Preferences/org.openemu.ProSystem.plist",
    "~/Library/Preferences/org.openemu.SNES9x.plist",
    "~/Library/Preferences/org.openemu.Stella.plist",
    "~/Library/Preferences/org.openemu.TwoMbit.plist",
    "~/Library/Preferences/org.openemu.VecXGL.plist",
    "~/Library/Preferences/org.openemu.VisualBoyAdvance.plist",
    "~/Library/Saved Application State/org.openemu.OpenEmu.savedState",
  ]
end