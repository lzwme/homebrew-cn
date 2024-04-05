cask "zui" do
  version "1.7.0"
  sha256 "db2d15bf021619b48ccd8d8e76c7efb6f1ef505d322744c384c97c492a28e401"

  url "https:github.combrimdatazuireleasesdownloadv#{version}Zui-#{version}.dmg",
      verified: "github.combrimdatazui"
  name "Zui"
  desc "Graphical user interface for exploring data in Zed lakes"
  homepage "https:zui.brimdata.iodocs"

  depends_on macos: ">= :high_sierra"

  app "Zui.app"

  zap trash: [
    "~LibraryApplication SupportZui",
    "~LibraryPreferencesio.brimdata.zui.plist",
    "~LibrarySaved Application Stateio.brimdata.zui.savedState",
  ]

  caveats do
    requires_rosetta
  end
end