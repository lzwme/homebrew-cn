cask "zui" do
  arch arm: "arm64", intel: "x64"

  version "1.18.0"
  sha256 arm:   "d28bd3144781cf1d8b6d2ba654e4c65b826c945004d480f2c0497235dfda4390",
         intel: "463e57018e87d201dd240e7199dc68d252eda2ab61ccae575efd7957dd7fc364"

  url "https:github.combrimdatazuireleasesdownloadv#{version}Zui-#{version}-#{arch}.dmg",
      verified: "github.combrimdatazui"
  name "Zui"
  desc "Graphical user interface for exploring data in Zed lakes"
  homepage "https:zui.brimdata.iodocs"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "Zui.app"

  zap trash: [
    "~LibraryApplication SupportZui",
    "~LibraryPreferencesio.brimdata.zui.plist",
    "~LibrarySaved Application Stateio.brimdata.zui.savedState",
  ]
end