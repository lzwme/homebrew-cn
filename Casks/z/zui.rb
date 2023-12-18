cask "zui" do
  version "1.4.1"
  sha256 "93257f8f0e0f0d2fe432aed1a6d0ed6ae4c67c0135e119893178d1da6805b4f5"

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