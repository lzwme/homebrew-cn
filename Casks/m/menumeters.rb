cask "menumeters" do
  version "2.1.6.1"
  sha256 "6c8a1a62e5f84ca043898e2503f4750c8cd8447588c6fb52d3be9c505a5cdff8"

  url "https:github.comyujitachMenuMetersreleasesdownload#{version}MenuMeters_#{version}.zip",
      verified: "github.comyujitachMenuMeters"
  name "MenuMeters for El Capitan (and later)"
  desc "Set of CPU, memory, disk, and network monitoring tools"
  homepage "https:member.ipmu.jpyuji.tachikawaMenuMetersElCapitan"

  livecheck do
    url "https:member.ipmu.jpyuji.tachikawaMenuMetersElCapitanMenuMeters-Update.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  app "MenuMeters.app"

  uninstall quit: "com.yujitach.MenuMeters"

  zap trash: [
    "~LibraryCachescom.yujitach.MenuMeters",
    "~LibraryPreferencescom.ragingmenace.MenuMeters.plist",
    "~LibraryPreferencescom.yujitach.MenuMeters.plist",
    "~LibraryPreferencesPanesMenuMeters.prefPane",
  ]
end