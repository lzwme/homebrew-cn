cask "zui" do
  version "1.6.0"
  sha256 "0b49a94853fc1c6c03af6efe77b8fd49b466ebae30ec60e0bea675f16f66bd40"

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