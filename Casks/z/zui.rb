cask "zui" do
  version "1.5.0"
  sha256 "36fa75d42472951a120a2b43af32bf91fbbabc9dc7200098182d0450c266354c"

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