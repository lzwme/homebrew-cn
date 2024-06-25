cask "zui" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "5264bdff147d714664d6bf33a692c94260688367991ea4f2749f2ba386db6e9e",
         intel: "3796937bdca394bad2d0d20a5b858915d9071492003bb5383cbebe3bf2ed2106"

  url "https:github.combrimdatazuireleasesdownloadv#{version}Zui-#{version}-#{arch}.dmg",
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