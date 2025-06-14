cask "hex-fiend" do
  version "2.18.1"
  sha256 "837041623a21eaae59b9b6c0bb7f75533938ab96580861ee7e276bb926e0e076"

  url "https:github.comridiculousfishHexFiendreleasesdownloadv#{version}Hex_Fiend_#{version.major_minor_patch.chomp(".0")}.dmg",
      verified: "github.comridiculousfishHexFiend"
  name "Hex Fiend"
  desc "Hex editor focussing on speed"
  homepage "https:ridiculousfish.comhexfiend"

  livecheck do
    url "https:raw.githubusercontent.comridiculousfishHexFiendmasterappappcast.xml"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Hex Fiend.app"
  binary "#{appdir}Hex Fiend.appContentsResourceshexf"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.ridiculousfish.hexfiend.sfl*",
    "~LibraryApplication Supportcom.ridiculousfish.HexFiend",
    "~LibraryCachescom.ridiculousfish.HexFiend",
    "~LibraryCookiescom.ridiculousfish.HexFiend.binarycookies",
    "~LibraryPreferencescom.ridiculousfish.HexFiend.plist",
    "~LibrarySaved Application Statecom.ridiculousfish.HexFiend.savedState",
  ]
end