cask "hex-fiend" do
  version "2.18.0"
  sha256 "b1fd1d3a2adb1a7d57f05d6fcd159cb33f917060bbdc85a456faf95cf8042076"

  url "https:github.comridiculousfishHexFiendreleasesdownloadv#{version}Hex_Fiend_#{version.major_minor_patch.chomp(".0")}.dmg",
      verified: "github.comridiculousfishHexFiend"
  name "Hex Fiend"
  desc "Hex editor focussing on speed"
  homepage "https:ridiculousfish.comhexfiend"

  livecheck do
    url :url
    strategy :github_latest
  end

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