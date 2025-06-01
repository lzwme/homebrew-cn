cask "vimr" do
  version "0.54.0,20250531.222551"
  sha256 "e726c0227e04a59b3b915d1b25c876984a4d67b5acfc2fb5b5292e8cb2e66405"

  url "https:github.comqvacuavimrreleasesdownloadv#{version.csv.first}-#{version.csv.second}VimR-v#{version.csv.first}.tar.bz2"
  name "VimR"
  desc "GUI for the Neovim text editor"
  homepage "https:github.comqvacuavimr"

  livecheck do
    url "https:raw.githubusercontent.comqvacuavimrrefsheadsmasterappcast.xml"
    strategy :sparkle do |item|
      item.nice_version.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "VimR.app"
  binary "#{appdir}VimR.appContentsResourcesvimr"

  zap trash: [
    "~LibraryCachescom.qvacua.VimR",
    "~LibraryPreferencescom.qvacua.VimR.menuitems.plist",
    "~LibraryPreferencescom.qvacua.VimR.plist",
    "~LibrarySaved Application Statecom.qvacua.VimR.savedState",
    "~LibraryWebKitcom.qvacua.VimR",
  ]
end