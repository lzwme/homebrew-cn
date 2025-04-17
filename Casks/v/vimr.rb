cask "vimr" do
  version "0.52.0,20250401.183326"
  sha256 "a1c824cc294df97500dba7ee553fc22424c1473aa12f8f1665097dbdf31d4130"

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